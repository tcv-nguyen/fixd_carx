class Api::V1::Entities::Post < Grape::Entity
  expose :title, :body
  expose(:author) { |post, options| post.user.name }
  expose(:rating) { |post, options| post.user.rating.to_f }
  expose(:posted_at) { |post, options| post.posted_at.strftime('%d %b %y') }
  expose :comments, as: 'comments', using: Api::V1::Entities::Comment
end
