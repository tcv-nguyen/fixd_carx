class Api::V1::Post < Grape::API
  namespace :post do
    post do
      post = current_user.posts.new(params.slice(:title, :body))
      if post.save
        status 200
        { message: 'Post Created' }
      else
        error!({ message: post.errors.full_messages.join('. ') }, 422)
      end
    end
  end
end
