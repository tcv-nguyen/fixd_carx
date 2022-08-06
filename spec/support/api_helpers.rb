RSpec.configure do |config|
  def response_body
    JSON.parse(response.body)
  end

  def response_message
    response_body['message']
  end
end
