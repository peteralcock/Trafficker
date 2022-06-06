class Slammer::AuthTokenTicket < ActiveRecord::Base
  include Slammer::ModelConcern::Ticket
  include Slammer::ModelConcern::ConsumableTicket

  self.ticket_prefix = 'ATT'.freeze

  def self.cleanup
    delete_all(['created_at < ?', Slammer.config.auth_token_ticket[:lifetime].seconds.ago])
  end

  def expired?
    (Time.now - (self.created_at || Time.now)) > Slammer.config.auth_token_ticket[:lifetime].seconds
  end

end
