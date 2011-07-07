Rails.application.config.middleware.use OmniAuth::Builder do  
  Settings = YAML.load_file("#{RAILS_ROOT}/config/application.yml")[RAILS_ENV]
  provider :twitter, Settings["twitter"]["consumer_key"], Settings["twitter"]["consumer_secret"]
end