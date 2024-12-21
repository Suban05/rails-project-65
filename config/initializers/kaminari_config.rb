# frozen_string_literal: true

# config/initializers/kaminari_config.rb
Kaminari.configure do |config|
  config.page_method_name = :page
  config.param_name = :page
end
