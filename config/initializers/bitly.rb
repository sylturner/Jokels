Bitly.configure do |config|
  Settings = YAML.load_file("#{RAILS_ROOT}/config/application.yml")[RAILS_ENV]
  config.api_version = Settings["bitly"]["api_version"]
  config.username = Settings["bitly"]["username"]
  config.api_key = Settings["bitly"]["api_key"]
end