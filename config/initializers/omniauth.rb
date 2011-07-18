Rails.application.config.middleware.use OmniAuth::Builder do  
  Settings = YAML.load_file("#{RAILS_ROOT}/config/application.yml")[RAILS_ENV]
  provider :twitter, Settings["twitter"]["consumer_key"], Settings["twitter"]["consumer_secret"], {:client_options => {:ssl => {:ca_path => Settings["ssl_ca_path"]}}}
  provider :facebook, Settings["facebook"]["app_id"], Settings["facebook"]["app_secret"], {:client_options => {:ssl => {:ca_path => Settings["ssl_ca_path"]}}, :scope => "user_about_me"}
end

# uncomment to debug errors from omniauth
#OmniAuth.config.on_failure do |env|
#  [200, {}, [env['omniauth.error'].to_yaml]]
#end