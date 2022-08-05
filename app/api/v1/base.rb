class Api::V1::Base < Grape::API
  prefix :v1

  mount Api::V1::User
  mount Api::V1::Post
  mount Api::V1::Comment
end
