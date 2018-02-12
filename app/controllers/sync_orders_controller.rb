class SyncOrdersController < ApiController
    def create
	@sync_order = parse_sync_order_request
	@sync_order.save 
	forward_or_welcome
	render xml: sync_order_response, content_type: 'text/xml; charset=UTF-8'
    end

    private

    def parse_sync_order_request
	doc = Nokogiri::XML(request.body.read)
	doc.remove_namespaces!

	sync_order = SyncOrder.new
	sync_order.user_id = doc.at_xpath("//ID").content
	sync_order.user_type = doc.at_xpath("//type").content.to_i
	sync_order.product_id = doc.at_xpath("//productID").content
	sync_order.service_id = doc.at_xpath("//serviceID").content
	sync_order.services_list = doc.at_xpath("//serviceList").content
	sync_order.update_type = doc.at_xpath("//updateType").content.to_i
	sync_order.update_time = DateTime.strptime(doc.at_xpath("//updateTime").content, '%Y%m%d%H%M%S')
	sync_order.update_description = doc.at_xpath("//updateDesc").content
	sync_order.effective_time = DateTime.strptime(doc.at_xpath("//effectiveTime").content, '%Y%m%d%H%M%S')
	sync_order.expiry_time = DateTime.strptime(doc.at_xpath("//expiryTime").content, '%Y%m%d%H%M')
#     sync_order.transaction_id = doc.xpath("//value").first.content
#     sync_order.order_key = doc.xpath("//value")[1].content
#     sync_order.mdspsubexpmode = doc.xpath("//value")[2].content.to_i
#     sync_order.object_type = doc.xpath("//value")[3].content.to_i
#     sync_order.traceunique_id = doc.xpath("//value")[4].content
#     sync_order.rent_success = doc.xpath("//value")[5].content == "true"

	sync_order
    end

    def sync_order_response
	namespaces = {
               "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
               "xmlns:loc" => "http://www.csapi.org/schema/parlayx/data/sync/v1_0/local"
                }

         builder = Nokogiri::XML::Builder.new { |xml|
         xml['soapenv'].Envelope(namespaces) do
            xml['soapenv'].Header

            xml['soapenv'].Body do
               xml['loc'].syncOrderRelationResponse do
                  xml['loc'].result(0)
                  xml['loc'].resultDescription('OK')
               end # end of sendSms
            end # end of Body
        end # end of Envelope
        }
    end

    def forward_or_welcome
	@service = ShortCodeService.find_by_service_id @sync_order.service_id
	#logger.info "service id: " + @sync_order.service_id
	if @service&.subscription_endpoint.present? then
	   notification = {
		phone_number: @sync_order.user_id,
		short_code: @service.short_code.code,
		notification_type: @sync_order.update_description.downcase == 'addition' ? 'activation' : 'deactivation'
	   } 
	    
	    ForwardNotificationJob.perform_later(@service.subscription_endpoint, notification)
	else
	    #TODO: Respond to subscriber with a default, generic welcome message 
	end
    end
end
