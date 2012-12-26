Twitter.configure do |config|
  settings = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]
  config.consumer_key = settings["twitter"]["consumer_key"]
  config.consumer_secret = settings["twitter"]["consumer_secret"]
end
