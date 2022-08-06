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

      describe 'without user_id'
      describe 'without rater_id'
      describe 'with invalid rating'
    end
  end
end
