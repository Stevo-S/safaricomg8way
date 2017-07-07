class CreateSmsNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :sms_notifications do |t|
      t.text :message
      t.string :sender_address, limit: 16
      t.string :service_id, limit: 16
      t.string :link_id
      t.string :trace_unique_id
      t.string :sms_service_activation_number, limit: 8
      t.datetime :date_time

      t.timestamps
    end
  end
end
