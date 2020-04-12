ActiveAdmin.register Subscription do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :request_id, :request_time_stamp, :transaction_id, :client_transaction_id, :language, :subscriber_life_cycle, :subscription_status, :next_billing_date, :subscription_type, :short_code, :channel, :operation, :offer_code, :msisdn, :offer_name, :reason
  #
  # or
  #
  # permit_params do
  #   permitted = [:request_id, :request_time_stamp, :transaction_id, :client_transaction_id, :language, :subscriber_life_cycle, :subscription_status, :next_billing_date, :type, :short_code, :channel, :operation, :offer_code, :msisdn, :offer_name, :reason]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
