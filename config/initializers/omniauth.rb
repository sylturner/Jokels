Rails.application.config.middleware.use OmniAuth::Builder do
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  Settings = YAML.load_file("#{RAILS_ROOT}/config/application.yml")[RAILS_ENV]
  provider :twitter, Settings["twitter"]["consumer_key"], Settings["twitter"]["consumer_secret"]
  # uncomment the following line if you need to grant jokels permissions to your facebook pages
  #provider :facebook, Settings["facebook"]["app_id"], Settings["facebook"]["app_secret"], {:scope => "user_about_me,manage_pages,publish_stream,offline_access"}
  provider :facebook, Settings["facebook"]["app_id"], Settings["facebook"]["app_secret"], {:scope => "user_about_me,publish_stream"}
  provider :browser_id, :name => "persona"
end

#uncomment to debug errors from omniauth
#OmniAuth.config.on_failure do |env|
  #[200, {}, [env['omniauth.error'].to_yaml]]
#end
