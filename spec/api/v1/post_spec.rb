require 'rails_helper'

describe 'Post API', type: :request do
  describe 'create new Post' do
    let(:params) { {title: 'Post title', body: 'This is post content'} }

    before do
      post '/api/v1/post', params: params
    end

    it 'should return status OK' do
      expect(JSON.parse(response.body)['status']).to eq(200)
    end
  end
end
