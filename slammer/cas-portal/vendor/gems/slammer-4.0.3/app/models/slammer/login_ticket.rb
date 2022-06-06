class Slammer::LoginTicket < ActiveRecord::Base
  include Slammer::ModelConcern::Ticket
  include Slammer::ModelConcern::ConsumableTicket

  self.ticket_prefix = 'LT'.freeze

  def self.cleanup
    delete_all(['created_at < ?', Slammer.config.login_ticket[:lifetime].seconds.ago])
  end

  def expired?
    (Time.now - (self.created_at || Time.now)) > Slammer.config.login_ticket[:lifetime].seconds
  end
end
