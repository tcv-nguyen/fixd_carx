class Api::V1::Post < Grape::API
  namespace :post do
    post do
      { status: 'Create Post' }
    end
  end
end
