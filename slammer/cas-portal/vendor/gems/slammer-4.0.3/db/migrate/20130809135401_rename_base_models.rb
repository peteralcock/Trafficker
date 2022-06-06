class RenameBaseModels < ActiveRecord::Migration
  def up
    # Login Tickets
    rename_table :login_tickets, :slammer_login_tickets
    unless index_exists?(:slammer_login_tickets, :ticket)
      add_index :slammer_login_tickets, :ticket, :unique => true
    end

    # Proxy Granting Tickets
    rename_table :proxy_granting_tickets, :slammer_proxy_granting_tickets
    unless index_exists?(:slammer_proxy_granting_tickets, :ticket)
      add_index :slammer_proxy_granting_tickets, :ticket, :unique => true
    end
    unless index_exists?(:slammer_proxy_granting_tickets, :iou)
      add_index :slammer_proxy_granting_tickets, :iou, :unique => true
    end
    unless index_exists?(:slammer_proxy_granting_tickets, :name => "index_slammer_proxy_granting_tickets_on_granter")
      # Uses a custom index name because the generated one exceeds the size limit
      add_index :slammer_proxy_granting_tickets, [:granter_type, :granter_id], :name => "index_slammer_proxy_granting_tickets_on_granter", :unique => true
    end

    # Proxy Tickets
    rename_table :proxy_tickets, :slammer_proxy_tickets
    unless index_exists?(:slammer_proxy_tickets, :ticket)
      add_index :slammer_proxy_tickets, :ticket, :unique => true
    end
    unless index_exists?(:slammer_proxy_tickets, :proxy_granting_ticket_id)
      add_index :slammer_proxy_tickets, :proxy_granting_ticket_id
    end

    # Service Rules
    rename_table :service_rules, :slammer_service_rules
    unless index_exists?(:slammer_service_rules, :url)
      add_index :slammer_service_rules, :url, :unique => true
    end

    # Service Tickets
    rename_table :service_tickets, :slammer_service_tickets
    unless index_exists?(:slammer_service_tickets, :ticket)
      add_index :slammer_service_tickets, :ticket, :unique => true
    end
    unless index_exists?(:slammer_service_tickets, :ticket_granting_ticket_id)
      add_index :slammer_service_tickets, :ticket_granting_ticket_id
    end

    # Ticket Granting Tickets
    rename_table :ticket_granting_tickets, :slammer_ticket_granting_tickets
    unless index_exists?(:slammer_ticket_granting_tickets, :ticket)
      add_index :slammer_ticket_granting_tickets, :ticket, :unique => true
    end

    # Two-Factor Authenticators
    rename_table :two_factor_authenticators, :slammer_two_factor_authenticators
    unless index_exists?(:slammer_two_factor_authenticators, :user_id)
      add_index :slammer_two_factor_authenticators, :user_id
    end

    # Users
    rename_table :users, :slammer_users
    unless index_exists?(:slammer_users, [:authenticator, :username])
      add_index :slammer_users, [:authenticator, :username], :unique => true
    end
  end

  def down
    remove_index :slammer_login_tickets, :ticket
    drop_table :slammer_login_tickets

    # Proxy Granting Tickets
    remove_index :slammer_proxy_granting_tickets, :ticket, :unique => true
    remove_index :slammer_proxy_granting_tickets, :iou, :unique => true
    remove_index :slammer_proxy_granting_tickets, [:granter_type, :granter_id], :name => "index_slammer_proxy_granting_tickets_on_granter", :unique => true
    drop_table :slammer_proxy_granting_tickets

    # Proxy Tickets
    remove_index :slammer_proxy_tickets, :ticket, :unique => true
    remove_index :slammer_proxy_tickets, :proxy_granting_ticket_id
    drop_table :slammer_proxy_tickets

    # Service Rules
    remove_index :slammer_service_rules, :url, :unique => true
    drop_table :slammer_service_rules

    # Service Tickets
    remove_index :slammer_service_tickets, :ticket, :unique => true
    remove_index :slammer_service_tickets, :ticket_granting_ticket_id
    drop_table :slammer_service_tickets

    # Ticket Granting Tickets
    remove_index :slammer_ticket_granting_tickets, :ticket, :unique => true
    drop_table :slammer_ticket_granting_tickets

    # Two-Factor Authenticators
    remove_index :slammer_two_factor_authenticators, :user_id
    drop_table :slammer_two_factor_authenticators

    # Users
    remove_index :slammer_users, [:authenticator, :username], :unique => true
    drop_table :slammer_users
  end
end
