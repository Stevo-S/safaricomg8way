ActiveAdmin.register ShortCodeService do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :short_code_id, :service_id, :name, :dlr_endpoint, :subscription_endpoint, :message_enpoint
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  form do |f|
    f.inputs "New Short Code Service" do
	f.input :short_code, as: :select, collection: ShortCode.all.collect {|s| [s.code, s.id]}
	f.input :name
	f.input :service_id, label: :service_id
	f.input :dlr_endpoint
	f.input :subscription_endpoint
	f.input :message_endpoint
    end

    f.actions
  end
end
