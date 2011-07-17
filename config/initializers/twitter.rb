Twitter.configure do |config|
  Settings = YAML.load_file("#{RAILS_ROOT}/config/application.yml")[RAILS_ENV]
  config.consumer_key = Settings["twitter"]["consumer_key"]
  config.consumer_secret = Settings["twitter"]["consumer_secret"]
end