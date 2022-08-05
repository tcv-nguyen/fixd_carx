class Api::V1::User < Grape::API
  namespace :user do
    get :timeline do
      { status: 'Return User Timeline' }
    end

    post :rate do
      { status: 'Rate User' }
    end
  end
end
