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
end
