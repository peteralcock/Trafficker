require 'grape'

class Slammer::API < Grape::API
  format :json

  mount Slammer::API::Resource::AuthTokenTickets
end
