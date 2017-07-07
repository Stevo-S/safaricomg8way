class DeliveryNotificationsController < ApiController
    def create
	@delivery_notification = parse_delivery_notification_request
        @delivery_notification.save	

	head :ok
    end

    private

    def parse_delivery_notification_request
	doc = Nokogiri::XML(request.body.read)
        
        logger.info "DLR: #{doc}"
        doc.remove_namespaces! 
        
        dlr = DeliveryNotification.new
        
        
        logger.info "DLR request minus namespaces\n: #{doc}"
        
        dlr.destination = doc.at_xpath("//address").content#.split(':')[1].strip
        dlr.delivery_status = doc.at_xpath("//deliveryStatus/deliveryStatus").content
        dlr.service_id = doc.at_xpath("//serviceId").content
        dlr.correlator = doc.at_xpath("//correlator").content
        dlr.trace_unique_id = doc.at_xpath("//traceUniqueID").content
        
        
        # logger.info "DLR Address: #{dlr.destination}"
        # logger.info "DLR Status: #{dlr.delivery_status}"
        # logger.info "DLR Service ID: #{dlr.service_id}"
        dlr	
    end
end
