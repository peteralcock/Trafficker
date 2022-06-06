class FixLengthOfTextFields < ActiveRecord::Migration
  def change
    change_column :slammer_proxy_tickets, :service, :text, :limit => nil
    change_column :slammer_service_tickets, :service, :text, :limit => nil
    change_column :slammer_ticket_granting_tickets, :user_agent, :text, :limit => nil
  end
end
