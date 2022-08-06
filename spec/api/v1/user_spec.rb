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
    let(:pre_spec) {}

    before do
      pre_spec
      get '/api/v1/user/timeline', params: { token: user.api_token }
    end

    describe 'when new Post has 4 Comments' do
      let(:pre_spec) do
        @post = create(:post, user: user, posted_at: Date.parse('2022/8/20'))
        create_list(:comment, 4, post: @post)
      end

      it 'should return correct data' do
        expect(response_body).to eq([
          {
            'display_date'  => '20 AUG 22', 
            'footer'        => '4.0',
            'record_type'   => 'post',
            'title'         => @post.title
          }
        ])
      end
    end

    describe 'when User commented on another Post' do
    end

    describe 'when User passed 4 stars'
    describe 'when request for 3 records on page 2'
    describe 'when there are mixed events'
  end
end
