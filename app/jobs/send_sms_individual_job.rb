class SendSmsIndividualJob < ApplicationJob
  queue_as :send_sms

  def perform(message_id)

    # uri = URI('http://localhost:3000/sms_messages')
    # send_request = Net::HTTP::Post.new uri
    # send_request.body = outbound_message.to_json
    # send_request.content_type = 'application/json; charset=UTF-8'

    # send_message = Net::HTTP.new(uri.host, uri.port) do |http|
	# http.request send_request
    # end
    #
   # SdpOperations.send_sms(outbound_message['text_message'], outbound_message['destination'], outbound_message['sender'],
#	outbound_message['service_id'], Time.now.strftime("%Y%m%d%H%M%S"), outbound_message['link_id'])
#
    sms_message = SmsMessage.find(message_id)
    destinations = [sms_message.destination]
    if sms_message then
	    # service_id = ShortCode.find_by_code(sms_message.sender)&.short_code_service.service_id
	    offer_code = OfferRoute.find_by_short_code(sms_message.sender)&.offer_code
	    begin 
		retries ||= 0
	    	SdpOperations.send_sms(sms_message.content, destinations, sms_message.sender,
		offer_code, Time.now.strftime("%Y%m%d%H%M%S"), sms_message.link_id)
	    rescue StandardError => error
		retry if (retries += 1) < 3
		puts error
            end
    end

  end
end
