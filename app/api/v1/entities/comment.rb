class Api::V1::Entities::Comment < Grape::Entity
  expose :message
  expose(:author) { |comment, options| comment.user.name }
  expose(:rating) { |comment, options| comment.user.rating.to_f }
  expose(:commented_at) { |comment, options| comment.commented_at.strftime('%d %b %y') }
end
