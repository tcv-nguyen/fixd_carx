class Api::V1::Post < Grape::API
  namespace :post do
    post do
      post = Post.new(params.slice(:title, :body))
      if post.save
        { message: 'Post Created' }
      else
        error!({ message: post.errors.full_messages.join('. ') }, 422)
      end
    end
  end
end
