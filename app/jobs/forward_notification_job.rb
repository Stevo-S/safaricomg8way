class ForwardNotificationJob < ApplicationJob
  queue_as :default

  def perform(endpoint, notification)
    uri = URI(endpoint)
    forward_notification_request = Net::HTTP::Post.new(uri)
    forward_notification_request.content_type = 'application/json'
    forward_notification_request.body = notification.to_json
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    forward_notification_response = http.request forward_notification_request
  end
end
