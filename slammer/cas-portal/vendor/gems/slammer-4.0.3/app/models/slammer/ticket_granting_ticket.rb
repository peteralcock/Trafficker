require 'user_agent'

class Slammer::TicketGrantingTicket < ActiveRecord::Base
  include Slammer::ModelConcern::Ticket

  self.ticket_prefix = 'TGC'.freeze

  belongs_to :user
  has_many :service_tickets, dependent: :destroy

  scope :active, -> { where(awaiting_two_factor_authentication: false).order('updated_at DESC') }

  def self.cleanup(user = nil)
    if user.nil?
      base = self
    else
      base = user.ticket_granting_tickets
    end
    tgts = base.where([
      '(created_at < ? AND awaiting_two_factor_authentication = ?) OR (created_at < ? AND long_term = ?) OR created_at < ?',
      Slammer.config.two_factor_authenticator[:timeout].seconds.ago,
      true,
      Slammer.config.ticket_granting_ticket[:lifetime].seconds.ago,
      false,
      Slammer.config.ticket_granting_ticket[:lifetime_long_term].seconds.ago
    ])
    Slammer::ServiceTicket.where(ticket_granting_ticket_id: tgts).destroy_all
    tgts.destroy_all
  end

  def browser_info
    unless self.user_agent.blank?
      user_agent = UserAgent.parse(self.user_agent)
      if user_agent.platform.nil?
        "#{user_agent.browser}"
      else
        "#{user_agent.browser} (#{user_agent.platform})"
      end
    end
  end

  def same_user?(other_ticket)
    if other_ticket.nil?
      false
    else
      other_ticket.user_id == self.user_id
    end
  end

  def expired?
    if awaiting_two_factor_authentication?
      lifetime = Slammer.config.two_factor_authenticator[:timeout]
    elsif long_term?
      lifetime = Slammer.config.ticket_granting_ticket[:lifetime_long_term]
    else
      lifetime = Slammer.config.ticket_granting_ticket[:lifetime]
    end
    (Time.now - (self.created_at || Time.now)) > lifetime
  end
end
