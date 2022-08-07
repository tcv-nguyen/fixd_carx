RSpec.configure do |config|
  def response_body
    JSON.parse(response.body)
  end

  def response_message
    response_body['message']
  end

  def clear_vcr(filename)
    FileUtils.rm_rf(Dir.glob(Rails.root.join('spec', 'vcr', "#{filename}.yml")))
  end
end
