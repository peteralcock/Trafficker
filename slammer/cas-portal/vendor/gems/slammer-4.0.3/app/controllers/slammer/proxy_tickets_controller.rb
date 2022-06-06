class Slammer::ProxyTicketsController < Slammer::ApplicationController
  include Slammer::ControllerConcern::TicketValidator

  before_action :load_ticket, only: [:proxy_validate]
  before_action :ensure_service_ticket_parameters_present, only: [:proxy_validate]

  before_action :load_proxy_granting_ticket, only: [:create]
  before_action :ensure_proxy_parameters_present, only: [:create]

  def proxy_validate
    validate_ticket(@ticket)
  end

  def create
    proxy_ticket = @proxy_granting_ticket.proxy_tickets.create!(service: params[:targetService])
    build_proxy_response(true, proxy_ticket: proxy_ticket)
  end

  private
  def load_ticket
    @ticket = case params[:ticket]
              when /\APT-/
                Slammer::ProxyTicket.where(ticket: params[:ticket]).first
              when /\AST-/
                Slammer::ServiceTicket.where(ticket: params[:ticket]).first
              end
  end

  def build_proxy_response(success, options = {})
    render xml: Slammer::ProxyResponseBuilder.new(success, options).build
  end

  def ensure_proxy_parameters_present
    if params[:pgt].nil? || params[:targetService].nil?
      build_proxy_response(false,
                           error_code: 'INVALID_REQUEST',
                           error_message: '"pgt" and "targetService" parameters are both required')
    end
  end

  def load_proxy_granting_ticket
    @proxy_granting_ticket = Slammer::ProxyGrantingTicket.where(ticket: params[:pgt]).first if params[:pgt].present?
    if @proxy_granting_ticket.nil?
      build_proxy_response(false,
                           error_code: 'BAD_PGT',
                           error_message: 'PGT not found')
    end
  end
end
