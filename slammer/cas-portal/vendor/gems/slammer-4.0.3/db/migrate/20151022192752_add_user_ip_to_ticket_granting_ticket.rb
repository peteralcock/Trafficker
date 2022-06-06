class AddUserIpToTicketGrantingTicket < ActiveRecord::Migration
  def up
    add_column :slammer_ticket_granting_tickets, :user_ip, :string
  end

  def down
    remove_column :slammer_ticket_granting_tickets, :user_ip
  end
end
