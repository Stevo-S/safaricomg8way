class CreateDeliveryNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_notifications do |t|
      t.string :destination, limit: 16
      t.string :delivery_status, limit: 50
      t.string :service_id, limit: 32
      t.string :correlator, limit: 50
      t.string :trace_unique_id, limit: 50

      t.timestamps
    end
  end
end
