require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '#calculate_rating!' do
    it 'should calculate correct rating' do
      rating_1 = create(:rating, user_id: user.id, rating: 2)
      rating_2 = create(:rating, user_id: user.id, rating: 1)
      rating_3 = create(:rating, user_id: user.id, rating: 4)

      expect(user.reload.rating).to eq(2.3)
    end
  end
end
