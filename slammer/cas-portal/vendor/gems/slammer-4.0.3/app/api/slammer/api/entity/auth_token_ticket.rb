require 'grape-entity'

class Slammer::API::Entity::AuthTokenTicket < Grape::Entity
  expose :ticket
end
