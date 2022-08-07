VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  # config.default_cassette_options = { match_requests_on: [:body] }
  config.ignore_localhost = true
  config.allow_http_connections_when_no_cassette = true
  config.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
end
