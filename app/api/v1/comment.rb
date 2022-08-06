class Api::V1::Comment < Grape::API
  namespace :comment do
    post do
      comment = current_user.comments.new(params.slice(:message, :post_id))
      if comment.save
        status 200
        { message: 'Comment Created' }
      else
        error!({ message: comment.errors.full_messages.join('. ') }, 422)
      end
    end

    delete do
      { status: 'Delete Comment'}
    end
  end
end
