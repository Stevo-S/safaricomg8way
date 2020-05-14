class SdpOperations

    # Intiialize details required to communicate with Safaricom SDP server
    @@sdp_server_address = Rails.application.credentials.sdp[:server_address]
    @@sdp_server_port = Rails.application.credentials.sdp[:server_port].to_s
    @@cp_id = Rails.application.credentials.sdp[:cp_id].to_s
    @@sdp_username = Rails.application.credentials.sdp[:username]
    @@sdp_password = Rails.application.credentials.sdp[:password]

    @@timestamp_string = Time.now.strftime("%Y%m%d%H%M%S")

    # SendSms operation used to send messages to Safaricom SDP server
    # for termination to mobile subscriber 
    def self.send_sms(message_text, destinations, sender, offer_code, correlator, linkid = nil)
	destinations.uniq!

	Rails.logger = Logger.new(STDOUT)
	Rails.logger.level = Logger::DEBUG    
	logger = Rails.logger

	url = URI(@@sdp_server_address + ':' + @@sdp_server_port + '/api/public/SDP/sendSMSRequest')
    	destinations.each_slice(Rails.application.credentials.recipients_per_request) do |destinations_slice|
	    
	    # logger.info 'Access Token: ' + access_token


#	    send_sms_request = Net::HTTP::Post.new(url)
#	    send_sms_request.content_type = 'application/json'
#	    send_sms_request["X-Authorization"] = "Bearer " + self.access_token
	    

	    send_sms_request_body = {
		requestId: Time.now.strftime("%Y%m%d%H%M%S"),
		channel: "APIGW",
		operation: "SendSMS",
		requestParam: 
		    {
			data:
			    [
				{
				    name:   	"LinkId",
				    value:	""#linkid.present? linkid : ""
				},
				{
				    name:	"OfferCode",
				    value:	offer_code
				},
				{
				    name:	"Content",
				    value:	message_text
				},
				{
				    name:	"CpId",
				    value:	@@cp_id
				}
			    ]  		    
		    }
	    }

	    hydra = Typhoeus::Hydra.hydra

	    destinations.each do |destination|
		send_sms_request_body[:requestParam][:data] << { name: "Msisdn", value: destination }

		request = Typhoeus::Request.new(
		    url,
		    method: :post,
		    body: send_sms_request_body.to_json,
		    headers: {
			"Content-Type": 'application/json',
			"X-Authorization": 'Bearer ' + self.access_token
		    }			
		)

		request.on_complete do |response|
		    puts response.body
		end

		hydra.queue request
	    end

	    hydra.run

#	    http = Net::HTTP.new(url.host, url.port)
#	    http.use_ssl = true if url.scheme == "https"

#	    begin
#		retries ||= 0
#		initial_delay_in_s = 1
#		send_sms_response = http.request send_sms_request
#	    rescue StandardError => error
		# Wait a little bit before retrying
		# sleep(retries * initial_delay_in_s)
#		if (retries += 1) < 10 
#		    retry
#		else
#		    raise error
#		end
#	    end		
		
#	    send_sms_response

	    
	end
    end


    def self.access_token
	Rails.cache.fetch("sdp_api_token", expires_in: 1.hour, skip_nil: true) do
	    url = URI(@@sdp_server_address + ':' + @@sdp_server_port + '/api/auth/login')
	    generate_token_request = Net::HTTP::Post.new(url)
	    generate_token_request.content_type = 'application/json'
	    generate_token_request["X-Requested-With"] = "XMLHttpRequest"
	    generate_token_request.body = {
		    username: @@sdp_username,
		    password: @@sdp_password
		}.to_json

	    http = Net::HTTP.new(url.host, url.port)
	    http.use_ssl = true if url.scheme == "https"

	    begin
		retries ||= 0
		initial_delay_in_s = 1
		generate_token_response = http.request generate_token_request
	    rescue StandardError => error
		# Wait a little bit before retrying
		# sleep(retries * initial_delay_in_s)
		if (retries += 1) < 10 
		    retry
		else
		    raise error
		end
	    end		

	    JSON.parse(generate_token_response.body)["token"]
	end
    end

end
