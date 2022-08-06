require 'rails_helper'

describe 'Base API', type: :request do
  describe 'authenticate User' do
    describe 'without token' do
      before do
        get '/api/v1/user/timeline', params: {}
      end

      it 'should return status 401' do
        expect(response.status).to eq(401)
      end

      it 'should return message' do
        expect(response_message).to eq('Invalid API Token')
      end
    end

    describe 'with token expired' do
      let(:user) { create(:user, api_token: 'valid-token', api_token_expired_at: 2.days.ago) }

      before do
        get '/api/v1/user/timeline', params: { token: user.api_token }
      end

      it 'should return status 401' do
        expect(response.status).to eq(401)
      end

      it 'should return message' do
        expect(response_message).to eq('API Token expired')
      end
    end
  end
end
