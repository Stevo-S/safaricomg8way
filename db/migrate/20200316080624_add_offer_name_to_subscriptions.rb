class AddOfferNameToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :offer_name, :string
  end
end
