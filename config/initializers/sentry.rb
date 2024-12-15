# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV.fetch('SENTRY_DSN', nil)
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.traces_sample_rate = 1.0
  config.profiles_sample_rate = 1.0
end
