require 'rails_helper'

describe 'Post API', type: :request do
  let(:user) { create(:user, with_api_token: true) }
  let(:post_params) { { title: 'Post title', body: 'This is post content' } }
  let(:valid_params) { post_params.merge(token: user.api_token) }

  before do
    post '/api/v1/post', params: params
  end

  describe 'create new Post without API token' do
    let(:params) { post_params }

    it 'should return status 401' do
      expect(response.status).to eq(401)
    end

    it 'should return invalid API token message' do
      expect(response_message).to eq('Invalid API Token')
    end
  end

  describe 'create new Post without API token' do
    let(:params) { valid_params }

    it 'should return status 200' do
      expect(response.status).to eq(200)
    end

    it 'should increase Post records' do
      expect(user.posts.count).to eq(1)
    end
  end

  describe 'create new Post missing data' do
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
