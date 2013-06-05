# -*- encoding : utf-8 -*-
Bitly.configure do |config|
  Settings = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]
  config.api_version = Settings["bitly"]["api_version"]
  config.login = Settings["bitly"]["username"]
  config.api_key = Settings["bitly"]["api_key"]
end
