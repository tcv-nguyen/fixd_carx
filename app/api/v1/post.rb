class Api::V1::Post < Grape::API
  namespace :post do
    get do
      post = Post.includes(comments: :user).find_by(id: params[:id])
      present post, with: Api::V1::Entities::Post
    end

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
