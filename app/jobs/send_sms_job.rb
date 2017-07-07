class SendSmsJob < ApplicationJob
  queue_as :default

  def perform(outbound_message)

    uri = URI('http://localhost:3000/sms_messages')
    send_request = Net::HTTP::Post.new uri
    send_request.body = outbound_message.to_json
    send_request.content_type = 'application/json; charset=UTF-8'

    send_message = Net::HTTP.new(uri.host, uri.port).start do |http|
	http.request send_request
    end
  end
end
