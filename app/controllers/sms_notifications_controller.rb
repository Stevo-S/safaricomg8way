class SmsNotificationsController < ApiController
def username
	"smartfame"
    end
    def password
	"5M4rtFam3!"
    end
    def sp_id
	"601957"
    end
    def current_time_string
	Time.now.strftime("%Y%m%d%H%M%S")	
    end
    def hashed_password
	Digest::MD5.hexdigest(sp_id + password + current_time_string)
    end 
  def create
    @sms_notification = parse_notify_sms_reception_request
    @sms_notification.save

    SendSmsJob.perform_later({
		destination: @sms_notification.sender_address,  
		message: @sms_notification.message,  
		sender: @sms_notification.sms_service_activation_number,
		linkId: @sms_notification.link_id,
		serviceId: @sms_notification.service_id
	})
	
    render xml: '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:loc="http://www.csapi.org/schema/parlayx/sms/notification/v2_2/local">    <soapenv:Header/>    <soapenv:Body>       <loc:notifySmsReceptionResponse/>    </soapenv:Body> </soapenv:Envelope>'
  end

  def start
    soap_namespaces =
	{
	    "xmlns:v2" => "http://www.huawei.com.cn/schema/common/v2_1" 
	}
    soap_header =
	{
	   "v2:RequestSOAPHeader": {
		"v2:sp_id": self.sp_id,
		"v2:sp_password": hashed_password,
		"v2:service_id": "6019572000003994",
		"v2:time_stamp": current_time_string
	   }
	}
    soap_message = {
	    "loc:reference": {
	    endpoint: "http://197.248.103.38:3000/sms_notifications",
		interface_name: "notifySmsReception",
		correlator: "123456"
	    },
 	    "loc:sms_service_activation_number": "1787"
	}

    soap_client = Savon.client do
	    wsdl "wsdl/parlayx_sms_notification_manager_service_2_3.wsdl"
	    namespaces soap_namespaces
	    env_namespace :soapenv
	    namespace_identifier :loc
	    pretty_print_xml :true
	    log true
	    logger Rails.logger
	    log_level :debug
	    soap_header soap_header
    end
    begin
	soap_client.call(:start_sms_notification, message: soap_message)
    rescue TypeError => error
	logger.info "empty response, assuming success"
    end

    render json: { message: "done" }
  end

  def stop
	soap_namespaces =
	{
	    "xmlns:v2" => "http://www.huawei.com.cn/schema/common/v2_1" 
	}
    soap_header =
	{
	   "v2:RequestSOAPHeader": {
		"v2:sp_id": self.sp_id,
		"v2:sp_password": hashed_password,
		"v2:service_id": "6019572000003994",
		"v2:time_stamp": current_time_string
	   }
	}
    soap_message = {
		"loc:correlator": "123456"
	}

    soap_client = Savon.client do
	    wsdl "wsdl/parlayx_sms_notification_manager_service_2_3.wsdl"
	    namespaces soap_namespaces
	    env_namespace :soapenv
	    namespace_identifier :loc
	    pretty_print_xml :true
	    log true
	    logger Rails.logger
	    log_level :debug
	    soap_header soap_header
    end
    begin
	soap_client.call(:stop_sms_notification, message: soap_message)
    rescue TypeError => error
	logger.info "empty response, assuming success"
    end

    render json: { message: "done" }
  end

  private

  def parse_notify_sms_reception_request
    doc = Nokogiri::XML(request.body.read)
    logger.info "NotifySMSReceptionRequest message: #{doc}"
    doc.remove_namespaces!
      
    sms_notification = SmsNotification.new
    sms_notification.message = doc.at_xpath("//message/message").content
    sms_notification.sender_address = doc.at_xpath("//senderAddress").content.split(':').last
    sms_notification.service_id = doc.at_xpath("//serviceId").content
    sms_notification.link_id = doc.at_xpath("//linkid").content
    sms_notification.trace_unique_id = doc.at_xpath("//traceUniqueID").content
#    sms_notification.correlator = doc.at_xpath("//correlator").content
    sms_notification.sms_service_activation_number = doc.at_xpath("//smsServiceActivationNumber").content.split(':').last
    sms_notification.date_time = doc.at_xpath("//dateTime").content
    
    #logger.info "Received SMS: #{sms_notification.message}"
    #logger.info "Received SMS serviceId: #{sms_notification.service_id}"
    
    sms_notification
  end

    
     
end
