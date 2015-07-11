class AddSessionIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :session_id, :string
  end
end
