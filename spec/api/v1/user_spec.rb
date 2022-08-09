require 'rails_helper'

describe 'User API V1', type: :request do
  let(:user) { create(:user) }

  describe 'POST rate' do
    let(:rater) { create(:user, with_api_token: true) }
    let(:valid_params) do
      {
        token: rater.api_token,
        user_id: user.id,
        rating: 4
      }
    end

    before do
      post '/api/v1/user/rate', params: params
    end

    describe 'with valid data' do
      let(:params) { valid_params }

      it 'should return status 200' do
        expect(response.status).to eq(200)
      end

      it 'should create Rating record' do
        expect(user.ratings.count).to eq(1)
      end
    end

    describe 'with invalid data' do
      describe 'without API token' do
        let(:params) { valid_params.except(:token) }
    
        it 'should return status 401' do
          expect(response.status).to eq(401)
        end
    
        it 'should return invalid API token message' do
          expect(response_message).to eq('Missing API Token')
        end
      end

      describe 'without user_id' do
        let(:params) { valid_params.except(:user_id) }
    
        it 'should return status 422' do
          expect(response.status).to eq(422)
        end
    
        it 'should return User must exist message' do
          expect(response_message).to eq('User must exist')
        end
      end

      describe 'with invalid rating' do
        let(:params) { valid_params.merge(rating: 6) }
    
        it 'should return status 422' do
          expect(response.status).to eq(422)
        end
    
        it 'should return User must exist message' do
          expect(response_message).to eq('Rating must be between 1 and 5')
        end
      end
    end
  end

  describe 'GET timeline' do
    let(:user) { create(:user, with_api_token: true) }
    let(:valid_params) { { token: user.api_token } }
    let(:params) { valid_params }
    let(:pre_spec) {}

    before do
      pre_spec
      get '/api/v1/user/timeline', params: params
    end

    describe 'when new Post has 4 Comments' do
      let(:pre_spec) do
        @post = create(:post, user: user, posted_at: Date.parse('2022/8/20'))
        create_list(:comment, 4, post: @post)
      end

      it 'should return correct data' do
        expect(response_body).to eq([
          {
            'description'     => '4',
            'event_time_at'   => '20 Aug 22', 
            'eventable_type'  => 'Post',
            'title'           => @post.title
          }
        ])
      end
    end

    describe 'when User commented on another Post' do
      let(:pre_spec) do
        @author = create(:user, rating: 3)
        @post = create(:post, user: @author)
        create(:comment, post: @post, user: user, commented_at: Date.parse('2022/8/21'))
      end

      it 'should return correct data' do
        expect(response_body).to eq([
          {
            'description'     => '3.0',
            'event_time_at'   => '21 Aug 22', 
            'eventable_type'  => 'Comment',
            'title'           => @author.name
          }
        ])
      end
    end

    describe 'when User passed 4 stars' do
      let(:pre_spec) { user.update(rating: 4, high_rating_at: Date.parse('2022/8/22')) }

      it 'should return correct data' do
        expect(response_body).to eq([
          {
            'description'     => '4.0',
            'event_time_at'   => '22 Aug 22', 
            'eventable_type'  => 'Rating',
            'title'           => 'Passed 4 stars!'
          }
        ])
      end
    end

    describe 'when User not passed 4 stars' do
      let(:pre_spec) { user.update(rating: 2, high_rating_at: Date.parse('2022/8/22')) }

      it 'should return correct data' do
        expect(response_body).to eq([])
      end
    end

    describe 'when request for 1 records on page 2' do
      # page = offset (start as 0)
      let(:params) { valid_params.merge(records: 1, page: 1) }
      let(:pre_spec) do
        @post_1, @post_2, @post_3 = create_list(:post, 3, user: user)
      end

      it 'should return correct data' do
        expect(response_body).to eq([
          {
            'description'     => '0',
            'event_time_at'   => @post_2.posted_at.strftime('%d %b %y'), 
            'eventable_type'  => 'Post',
            'title'           => @post_2.title
          }
        ])
      end
    end

    describe 'when there are mixed events' do
      let(:pre_spec) do
        # User got high_rating
        user.update(rating: 4.4, high_rating_at: Date.parse('2022/8/22'))
        # Create Post and 4 Comments
        @post = create(:post, user: user, posted_at: Date.parse('2022/8/20'))
        create_list(:comment, 4, post: @post)
        # Create Comment for current_user
        @author = create(:user, rating: 3.5)
        @other_post = create(:post, user: @author)
        create(:comment, post: @other_post, user: user, commented_at: DateTime.parse('2022/8/21 16:00'))
        @new_repo = create(:event, :new_repo, user: user, event_time_at: DateTime.parse('2022/8/21 22:00'))
      end

      it 'should return correct data' do
        expect(response_body).to eq([
          {
            'description'     => '4.4',
            'event_time_at'   => '22 Aug 22', 
            'eventable_type'  => 'Rating',
            'title'           => 'Passed 4 stars!'
          },
          {
            'description'     => @new_repo.description,
            'event_time_at'   => '21 Aug 22', 
            'eventable_type'  => 'GithubEvent',
            'title'           => @new_repo.title
          },
          {
            'description'     => '3.5',
            'event_time_at'   => '21 Aug 22', 
            'eventable_type'  => 'Comment',
            'title'           => @author.name
          },
          {
            'description'     => '4',
            'event_time_at'   => '20 Aug 22', 
            'eventable_type'  => 'Post',
            'title'           => @post.title
          }
        ])
      end
    end

    describe 'when User has GithubEvent' do
      let(:pre_spec) do
        # Reverse order
        @new_repo = create(:event, :new_repo, user: user, event_time_at: Date.parse('2022/8/20'))
        @new_pr = create(:event, :new_pr, user: user, event_time_at: Date.parse('2022/8/21'))
        @merge_pr = create(:event, :merged, user: user, event_time_at: Date.parse('2022/8/22'))
        @commit = create(:event, :commit, user: user, event_time_at: Date.parse('2022/8/23'))
      end

      it 'should return correct data' do
        expect(response_body).to eq([
          {
            'description'     => @commit.description,
            'event_time_at'   => '23 Aug 22', 
            'eventable_type'  => 'GithubEvent',
            'title'           => @commit.title
          },
          {
            'description'     => @merge_pr.description,
            'event_time_at'   => '22 Aug 22', 
            'eventable_type'  => 'GithubEvent',
            'title'           => @merge_pr.title
          },
          {
            'description'     => @new_pr.description,
            'event_time_at'   => '21 Aug 22', 
            'eventable_type'  => 'GithubEvent',
            'title'           => @new_pr.title
          },
          {
            'description'     => @new_repo.description,
            'event_time_at'   => '20 Aug 22', 
            'eventable_type'  => 'GithubEvent',
            'title'           => @new_repo.title
          }
        ])
      end
    end

    describe 'when there is no data' do
      it 'should return empty array' do
        expect(response_body).to eq([])
      end
    end
  end
end
