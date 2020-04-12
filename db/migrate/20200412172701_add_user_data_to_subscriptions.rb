class AddUserDataToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :user_data, :string
  end
end
