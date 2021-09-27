require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dokochika
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Asia/Tokyo"
    # config.eager_load_paths << Rails.root.join("extras")

    # デフォルトのlocaleを日本語(:ja)にする
    config.i18n.default_locale = :ja
    #lib/以下のtask以外のファイルが読み込まれるようにする
    config.paths.add 'lib', eager_load: true
  end
end
