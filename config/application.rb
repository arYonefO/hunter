require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(:default, Rails.env)

module LecheAsada
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    I18n.enforce_available_locales = false

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.middleware.use Rack::Cors do
      allow do
        origins 'localhost:3000', '127.0.0.1:3000', 'www.graffi.so', 'localhost:3002', '127.0.0.1:3002',
                'graffi.so', 'https://www.graffi.so',
                'https://graffi.so', 'obscure-hollows-9858.herokuapp.com',
                'http://www.graffi.so', 'http://graffi.so', 'origin'
        resource '/feed', :headers => :any, :methods => [:get]
      end
    end
  end
end
