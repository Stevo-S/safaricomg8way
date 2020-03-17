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
    def self.send_sms(message_text, destinations, sender, service_id, correlator, linkid = nil)
	destinations.uniq!
	
    	destinations.each_slice(Rails.application.credentials.recipients_per_request) do |destinations_slice|
		#TODO: Add Send SMS logic


	end
    end

end
