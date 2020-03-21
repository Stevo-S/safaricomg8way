class SdpOperations

    # Intiialize details required to communicate with Safaricom SDP server
    @@sdp_server_address = Rails.application.credentials.sdp[:server_address]
    @@sdp_server_port = Rails.application.credentials.sdp[:server_port]
    @@cp_id = Rails.application.credentials.sdp[:cp_id].to_s
    @@sdp_username = Rails.application.credentials.sdp[:username]
    @@sdp_password = Rails.application.credentials.sdp[:password]

    @@timestamp_string = Time.now.strftime("%Y%m%d%H%M%S")

    # SendSms operation used to send messages to Safaricom SDP server
    # for termination to mobile subscriber 
    def self.send_sms(message_text, destinations, sender, offer_code, correlator, linkid = nil)
	destinations.uniq!
	
	url = URI(@@sdp_server_address + ':' + @@sdp_server_port + '/api/public/SDP/sendSMSRequest')
    	destinations.each_slice(Rails.application.credentials.recipients_per_request) do |destinations_slice|
	    #TODO: Add Send SMS logic
	    send_sms_request = Net::HTTP::Post.new(url)
	    send_sms_request.content_type = 'application/json'
	    send_sms_request["X-Authorization"] = "Bearer " + access_token
	    
	    send_sms_request.body = {
		requestId: Time.now.to_string,
		channel: "APIGW",
		operation: "SendSMS",
		requestParam: 
		    {
			data:
			    [
				LinkId:		linkid,
				Msisdn: 	destinations,
				OfferCode:	offer_code,
				Content:	message_text,
				CpId:		@@cp_id
			    ]
		    }
	    }
	end
    end


    def access_token
	Rails.cache.fetch("#{cache_key_with_version}/sdp_api_token", expires_in: 1.hour) do
	    url = URI(@@sdp_server_address + ':' + @@sdp_server_port + '/api/auth/login')
	    generate_token_request = Net::HTTP::Post.new(url)
	    generate_token_request.content_type = 'application/json'
	    generate_token_request["X-Requested-With"] = "XMLHttpRequest"
	    generate_token_request.body = {
		    username: @@sdp_username,
		    password: @@sdp_password
		}to_json

	    JSON.parse(response.body)["access_token"]
	end
    end

end
