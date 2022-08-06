class Api::V1::Post < Grape::API
  namespace :post do
    post do
      post = Post.new(params.slice(:title, :body))
      if post.save
        { message: 'Post Created', status: 200 }
      else
        { message: post.errors.full_messages.join('. '), status: 422 }
      end
    end
  end
end
