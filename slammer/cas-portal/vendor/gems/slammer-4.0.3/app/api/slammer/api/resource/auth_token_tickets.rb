require 'grape'

class Slammer::API::Resource::AuthTokenTickets < Grape::API
  resource :auth_token_tickets do
    desc 'Create an auth token ticket'
    post do
      @ticket = Slammer::AuthTokenTicket.create
      Rails.logger.debug "Created auth token ticket '#{@ticket.ticket}'"
      present @ticket, with: Slammer::API::Entity::AuthTokenTicket
    end
  end
end
