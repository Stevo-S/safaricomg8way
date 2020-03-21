require 'sidekiq'

Sidekiq.configure_server do |config|
    config.redis = { namespace: 'safaricomg8way', url: 'redis://localhost:6379/17' }
end

Sidekiq.configure_client do |config|
    config.redis = { namespace: 'safaricomg8way', url: 'redis://localhost:6379/17' }
end
