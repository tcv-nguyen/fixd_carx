require 'rails_helper'

describe 'Post API', type: :request do
  describe 'create new Post without API token' do
    let(:params) { {title: 'Post title', body: 'This is post content'} }

    before do
      post '/api/v1/post', params: params
    end

    it 'should return status 401' do
      expect(response.status).to eq(401)
    end

    it 'should return message' do
      expect(response_message).to eq('Invalid API Token')
    end
  end
end
