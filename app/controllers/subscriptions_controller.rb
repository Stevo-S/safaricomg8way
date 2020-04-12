class SubscriptionsController < ApiController
    def create
    	@subscription = Subscription.create(subscription_params)

	route_subscription 

	render json: @subscription
    end

    private

    def subscription_params
	subscription_details = {}

	subscription_details[:request_id] = params[:requestId]
	subscription_details[:request_time_stamp] = params[:requestTimeStamp]
	params[:requestParam][:data].each do |datum|
	    if not datum[:name].downcase == 'type' then 
	        subscription_details[datum[:name].underscore] = datum[:value]
	    else
		subscription_details[:subscription_type] = datum[:value]
	    end
        end	

	if (params[:requestParam][:additionalData]) then
	    params[:requestParam][:additionalData].each do |datum|
		subscription_details[datum[:name].underscore] = datum[:value]
	    end
	end
	
	new_params = ActionController::Parameters.new({ subscription: subscription_details })

    	new_params.require(:subscription).permit(:request_id, :request_time_stamp,
		:transaction_id, :client_transaction_id, :language, :subscriber_life_cycle,
		:subscription_status, :next_billing_date, :subscription_type, :short_code, :channel,
		:operation, :offer_code, :msisdn, :consent_value, :user_data)	
    end

    def route_subscription 
	puts @subscription.to_s
	offer_route = OfferRoute.find_by offer_code: @subscription.offer_code

	if offer_route then
	    notification = {
	      phone_number: @subscription.msisdn,
	      short_code: @subscription.short_code,
	      notification_type: @subscription.subscription_type.downcase
	    }

	    if notification[:notification_type] == 'activation' then
		ForwardNotificationJob.perform_later(offer_route.subscription_endpoint, notification) if offer_route.subscription_endpoint.present?
	    elsif notification[:notification_type] == 'consent' then
		# Do nothing for now
		# Decide later on if we should forward this as well or not
		puts("Consent notification")
	    else
		ForwardNotificationJob.perform_later(offer_route.unsubscription_endpoint, notification) if offer_route.unsubscription_endpoint.present?
	    end
	end
    end
end
