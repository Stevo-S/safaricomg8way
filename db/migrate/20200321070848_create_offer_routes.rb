class CreateOfferRoutes < ActiveRecord::Migration[6.0]
  def change
    create_table :offer_routes do |t|
      t.string :offer_code
      t.string :name
      t.string :description
      t.string :short_code
      t.string :activation_keywords
      t.string :deactivation_keywords
      t.string :mo_endpoint
      t.string :subscription_endpoint
      t.string :unsubscription_endpoint
      t.string :dlr_endpoint
      t.boolean :active

      t.timestamps
    end
  end
end
