class AddConsentValueToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :consent_value, :string
  end
end
