ActiveAdmin.register OfferRoute do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :offer_code, :name, :description, :short_code, :activation_keywords, :deactivation_keywords, :mo_endpoint, :subscription_endpoint, :unsubscription_endpoint, :dlr_endpoint, :active
  #
  # or
  #
  # permit_params do
  #   permitted = [:offer_code, :name, :description, :short_code, :activation_keywords, :deactivation_keywords, :mo_endpoint, :subscription_endpoint, :unsubscription_endpoint, :dlr_endpoint, :active]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
