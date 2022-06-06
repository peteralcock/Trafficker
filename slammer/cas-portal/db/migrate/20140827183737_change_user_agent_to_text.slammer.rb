# This migration comes from slammer (originally 20140821142611)
class ChangeUserAgentToText < ActiveRecord::Migration
  def change
    change_column :slammer_ticket_granting_tickets, :user_agent, :text
  end
end
