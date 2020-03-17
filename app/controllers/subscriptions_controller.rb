class SubscriptionsController < ApiController
    def create
    	@subscription = subscription_details(params)

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
end
