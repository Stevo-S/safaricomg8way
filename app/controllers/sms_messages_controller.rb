class SmsMessagesController < ApiController

    wrap_parameters format: [:json]
    def create

	destination = params[:destination]
	sms = params[:message]
	sender = params[:sender]
	link_id = params[:linkId]	

	# service_id = params[:serviceId]
	@short_code = ShortCode.find_by_code(sender)
	service_id = @short_code&.short_code_service&.service_id
	SdpOperations.send_sms(sms, destination, sender, service_id, Time.now.strftime("%Y%m%d%H%M%S"), link_id)
	render json: { message_id: 42 }
    end
end
