class ChangeServiceToText < ActiveRecord::Migration
  def change
    change_column :slammer_proxy_tickets, :service, :text
    change_column :slammer_service_tickets, :service, :text
  end
end
