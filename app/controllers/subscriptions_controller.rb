class SubscriptionsController < ApiController
    def create
    	@subscription = subscription_details(params)
	@subscription.save

	route_subscription 

	render json: @subscription
    end

    private

    def subscription_details(params)
	subscription = Subscription.new

	subscription.request_id = params[:requestId]
	subscription.request_time_stamp = params[:requestTimeStamp]
	params[:requestParam][:data].each do |datum|
	   subscription[datum[:name].underscore] = datum[:value]
        end	
	
	subscription
    end

    def route_subscription 
	puts @subscription.to_s
	offer_route = OfferRoute.find_by offer_code: @subscription.offer_code

	if offer_route then
	    notification = {
	      phone_number: @subscription.msisdn,
	      short_code: @subscription.short_code,
	      notification_type: @subscription.type.downcase.start_with?( "activ") ? 'activation' : 'deactivation'
	    }

	    if notification[:notification_type] == 'activation'
		ForwardNotificationJob.perform_later(offer_route.subscription_endpoint, notification) if offer_route.subscription_endpoint.present?
	    else
		ForwardNotificationJob.perform_later(offer_route.unsubscription_endpoint, notification) if offer_route.unsubscription_endpoint.present?
	    end
	end
    end
end
