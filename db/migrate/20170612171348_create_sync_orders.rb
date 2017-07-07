class CreateSyncOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :sync_orders do |t|
      t.string :user_id, limit: 16
      t.integer :user_type
      t.string :product_id, limit: 16
      t.string :service_id, limit: 32
      t.string :services_list
      t.integer :update_type
      t.string :update_description, limit: 16
      t.datetime :update_time
      t.datetime :effective_time
      t.datetime :expiry_time
      t.string :transaction_id
      t.string :order_key
      t.integer :mdspsubexpmode
      t.integer :object_type
      t.boolean :rent_success

      t.timestamps
    end
  end
end
