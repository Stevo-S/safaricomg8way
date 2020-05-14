class SmsMessagesController < ApiController

    wrap_parameters format: [:json]
    def create

	destinations = params[:destination]
	sms = params[:message]
	sender = params[:sender]
	link_id = params[:linkId]	

	# service_id = params[:serviceId]
	@short_code = ShortCode.find_by_code(sender)
	service_id = @short_code&.short_code_service&.service_id
	# SdpOperations.send_sms(sms, destination, sender, service_id, Time.now.strftime("%Y%m%d%H%M%S"), link_id)
	
	#outbound_message = {
	#    text_message: sms,
	#    destination: destination,
	#    sender: sender,
	#    service_id: service_id,
	#    link_id: link_id			
	#}
	
	sms_messages = SmsMessage.create(destinations.collect do
		 |destination| { content: sms, sender: sender, destination: destination, link_id: link_id}
	 end )

	SendSmsJob.perform_later(sms_messages.pluck(:id))

	#sms_messages.each do |sms|
	#    SendSmsIndividualJob.perform_later(sms.id)
	#end

	render json: { status: 'queued for sending' }
    end
end
