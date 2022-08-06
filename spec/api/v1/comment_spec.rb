require 'rails_helper'

describe 'Comment API', type: :request do
  let(:user) { create(:user, with_api_token: true) }
  let(:blog) { create(:post, user: user) }
  let(:valid_params) do
    {
      token: user.api_token,
      post_id: blog.id,
      message: 'New comment message'
    }
  end

  before do
    post '/api/v1/comment', params: params
  end

  describe 'POST Comment' do
    describe 'with valid token' do
      let(:params) { valid_params }

      it 'should return status 200' do
        expect(response.status).to eq(200)
      end

      it 'should increase Comment records' do
        expect(user.comments.count).to eq(1)
      end
    end

    describe 'with missing data' do
      describe 'without API token' do
        let(:params) { valid_params.except(:token) }
    
        it 'should return status 401' do
          expect(response.status).to eq(401)
        end
    
        it 'should return invalid API token message' do
          expect(response_message).to eq('Missing API Token')
        end
      end

      describe 'without message' do
        let(:params) { valid_params.except(:message) }

        it 'should return status 422' do
          expect(response.status).to eq(422)
        end

        it 'should return error message' do
          expect(response_message).to eq("Message can't be blank")
        end
      end

      describe 'without post_id' do
        let(:params) { valid_params.except(:post_id) }

        it 'should return status 422' do
          expect(response.status).to eq(422)
        end

        it 'should return Post must exist error message' do
          expect(response_message).to eq('Post must exist')
        end
      end
    end
  end

  describe 'DELETE Comment' do
    let(:comment) { create(:comment, user: user, post: blog) }
    let(:valid_params) { { token: user.api_token, id: comment.id } }

    before do
      delete '/api/v1/comment', params: params
    end

    describe 'with valid data' do
      let(:params) { valid_params }

      it 'should return status 200' do
        expect(response.status).to eq(200)
      end

      it 'should decrease Comment records' do
        expect(user.comments.count).to eq(0)
      end
    end

    describe 'with invalid data' do
      describe 'without API token' do
        let(:params) { valid_params.except(:token) }
    
        it 'should return status 401' do
          expect(response.status).to eq(401)
        end
    
        it 'should return Missing API token message' do
          expect(response_message).to eq('Missing API Token')
        end
      end

      describe 'without Comment ID' do
        let(:params) { valid_params.except(:id) }

        it 'should return status 422' do
          expect(response.status).to eq(422)
        end

        it 'should return error message' do
          expect(response_message).to eq('Cannot find Comment')
        end
      end

      describe 'with invalid Comment ID' do
        let(:params) { valid_params.merge(id: comment.id + 1) }

        it 'should return status 422' do
          expect(response.status).to eq(422)
        end

        it 'should return error message' do
          expect(response_message).to eq('Cannot find Comment')
        end
      end

      describe 'with Comment ID not belongs to User' do
        let(:other_comment) { create(:comment) }
        let(:params) { valid_params.merge(id: other_comment.id) }

        it 'should return status 422' do
          expect(response.status).to eq(422)
        end

        it 'should return error message' do
          expect(response_message).to eq('Cannot find Comment')
        end
      end
    end
  end
end
