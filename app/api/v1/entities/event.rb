class Api::V1::Entities::Event < Grape::Entity
  expose(:description) do |event, options|
    event.eventable_type == 'Post' ? Post.find(event.eventable_id).comments.count.to_s : event.description
  end
  expose(:event_time_at) { |event, options| event.event_time_at.strftime('%d %b %y') }
  expose :eventable_type, :title
end
