class Api::V1::Comment < Grape::API
  namespace :comment do
    post do
      { status: 'Create Comment' }
    end

    delete do
      { status: 'Delete Comment'}
    end
  end
end
