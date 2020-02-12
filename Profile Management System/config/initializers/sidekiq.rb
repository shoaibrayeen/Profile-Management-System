require 'sidekiq'
#require 'sidekiq-cron'
Sidekiq.configure_client do |config|
	config.redis = { url: "redis://localhost:6379/0"}
end
Sidekiq.configure_server do |config|
	config.redis = { url: "redis://localhost:6379/0"}
end