class Api::V1::User < Grape::API
  namespace :user do
    get :timeline do
      current_user.fetch_github_events if current_user.github_username.present?
      current_user.timeline(params.slice(:records, :page).symbolize_keys)
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
