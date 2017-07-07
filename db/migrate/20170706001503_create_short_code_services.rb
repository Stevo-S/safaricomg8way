class CreateShortCodeServices < ActiveRecord::Migration[5.1]
  def change
    create_table :short_code_services do |t|
      t.string :name, limit: 32
      t.string :service_id, limit: 16
      t.string :dlr_enpoint
      t.string :subscription_endpoint
      t.string :message_endpoint
      t.references :short_code, foreign_key: true

      t.timestamps
    end
  end
end
