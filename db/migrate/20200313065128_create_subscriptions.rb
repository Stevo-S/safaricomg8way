class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.string :request_id
      t.string :request_time_stamp
      t.string :transaction_id
      t.string :client_transaction_id
      t.string :language
      t.string :subscriber_life_cycle
      t.string :subscription_status, limit: 1
      t.string :next_billing_date
      t.string :type
      t.string :short_code, limit: 5
      t.string :channel
      t.string :operation
      t.string :offer_code
      t.string :msisdn, limit: 12

      t.timestamps
    end
  end
end
