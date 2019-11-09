class SendSmsJob < ApplicationJob
  queue_as :send_sms

  def perform(message_ids)

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
    sms_message = SmsMessage.find(message_ids.first)
    destinations = SmsMessage.find(message_ids).pluck(:destination)
    if sms_message then
	    service_id = ShortCode.find_by_code(sms_message.sender)&.short_code_service.service_id
	    begin 
		retries ||= 0
	    	SdpOperations.send_sms(sms_message.content, destinations, sms_message.sender,
		service_id, Time.now.strftime("%Y%m%d%H%M%S"), sms_message.link_id)
	    rescue
		retry if (retries += 1) < 3
            end
    end

  end
end
