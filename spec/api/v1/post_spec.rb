require 'rails_helper'

describe 'Post API', type: :request do
  let(:user) { create(:user, with_api_token: true) }
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

  describe 'create new Post with valid token' do
    let(:params) { valid_params }

    it 'should return status 200' do
      expect(response.status).to eq(200)
    end

    it 'should increase Post records' do
      expect(user.posts.count).to eq(1)
    end
  end

  describe 'create new Post with missing data' do
    describe 'without API token' do
      let(:params) { valid_params.except(:token) }
  
      it 'should return status 401' do
        expect(response.status).to eq(401)
      end
  
      it 'should return invalid API token message' do
        expect(response_message).to eq('Invalid API Token')
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
