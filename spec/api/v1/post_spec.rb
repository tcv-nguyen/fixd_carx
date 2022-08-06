require 'rails_helper'

describe 'Post API', type: :request do
  let(:user) { create(:user, with_api_token: true) }

  describe 'POST Post' do
    let(:valid_params) do
      {
        token: user.api_token,
        title: 'Post title',
        body: 'This is post content'
      }
    end

    before do
      post '/api/v1/post', params: params
    end

    describe 'with valid token' do
      let(:params) { valid_params }

      it 'should return status 200' do
        expect(response.status).to eq(200)
      end

      it 'should increase Post records' do
        expect(user.posts.count).to eq(1)
      end
    end

    describe 'with missing data' do
      describe 'without API token' do
        let(:params) { valid_params.except(:token) }
    
        it 'should return status 401' do
          expect(response.status).to eq(401)
        end
    
        it 'should return Missing API token message' do
          expect(response_message).to eq('Missing API Token')
        end
      end

      describe 'with missing title' do
        let(:params) { valid_params.except(:title) }

        it 'should return status 422' do
          expect(response.status).to eq(422)
        end

        it 'should return error message' do
          expect(response_message).to eq("Title can't be blank")
        end
      end
    end
  end

  describe 'GET Post' do
    # Name 'blog' to distinguish with post method
    let(:author) { create(:user, rating: 4.1) }
    let(:blog) { create(:post, user: author, posted_at: Date.parse('2022/8/20')) }
    let(:valid_params) { { token: user.api_token, id: blog.id } }

    before do
      @comment_json = 4.times.each_with_object([]) do |n, array|
        index = n + 1
        new_author = instance_variable_set("@author_#{index}", create(:user, rating: index))
        commented_at = Date.parse("2022/8/#{20 + index}")
        comment = instance_variable_set "@comment_#{index}", create(:comment, post: blog, 
          user: new_author, commented_at: commented_at)
        
        # collect json result for better testing of the result
        array.push({
          'author' => new_author.name,
          'rating' => new_author.rating,
          'message' => comment.message,
          'commented_at' => commented_at.strftime('%d %b %y')
        })
      end
      
      get '/api/v1/post', params: params
    end

    describe 'with valid params' do
      let(:params) { valid_params }

      it 'should return correct data' do
        expect(response_body).to eq({
          'title'   => blog.title,
          'body'    => blog.body,
          'author'  => author.name,
          'rating'  => author.rating.to_f,
          'posted_at' => '20 Aug 22',
          'comments'  => @comment_json
        })
      end
    end
  end
end
