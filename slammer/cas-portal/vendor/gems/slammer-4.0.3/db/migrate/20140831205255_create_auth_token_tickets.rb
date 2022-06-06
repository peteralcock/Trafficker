class CreateAuthTokenTickets < ActiveRecord::Migration
  def change
    create_table :slammer_auth_token_tickets do |t|
      t.string :ticket, :null => false

      t.timestamps
    end
    add_index :slammer_auth_token_tickets, :ticket, :unique => true
  end
end
