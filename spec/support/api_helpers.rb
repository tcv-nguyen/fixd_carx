RSpec.configure do |config|
  def response_message
    JSON.parse(response.body)['message']
  end
end
