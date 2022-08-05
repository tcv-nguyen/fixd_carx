class Api < Grape::API
  format :json

  mount Api::V1::Base
end