class RenameTypeToSubscriptionTypeInSubscriptions < ActiveRecord::Migration[6.0]
  def change
    rename_column :subscriptions, :type, :subscription_type
  end
end
