class AddReasonToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :reason, :string
  end
end
