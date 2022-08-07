class Api::V1::Base < Grape::API
  prefix :v1

  params do
    requires :token, type: String, desc: 'API Token'
  end

  helpers Api::V1::Helpers::Authenticate

  before { authenticate! }

  mount Api::V1::User
  mount Api::V1::Post
  mount Api::V1::Comment
end
