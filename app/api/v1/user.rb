class Api::V1::User < Grape::API
  namespace :user do
    get :timeline do
      current_user.timeline(*params.slice(:records, :offset))
    end

    post :rate do
      rating = Rating.new(params.slice(:rating, :user_id).merge(rater_id: current_user.id))
      if rating.save
        status 200
        { message: 'Rating created' }
      else
        error!({ message: rating.errors.full_messages.join('. ') }, 422)
      end
    end
  end
end
