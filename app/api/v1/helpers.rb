module Api::V1::Helpers
  extend Grape::API::Helpers

  def authenticate!
    @current_user = User.find_by(api_token: params[:token])
    error!({ message: 'Invalid API Token' }, 401) if current_user.blank?
    error!({ message: 'API Token expired' }, 401) if current_user.api_token_expired?
  end

  def current_user
    @current_user
  end
end
