# -*- encoding : utf-8 -*-
Rails.application.config.middleware.use OmniAuth::Builder do
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  settings = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]
  provider :twitter, settings["twitter"]["consumer_key"], settings["twitter"]["consumer_secret"]
  # uncomment the following line if you need to grant jokels permissions to your facebook pages
  #provider :facebook, settings["facebook"]["app_id"], settings["facebook"]["app_secret"], {:scope => "user_about_me,manage_pages,publish_stream,offline_access"}
  provider :facebook, settings["facebook"]["app_id"], settings["facebook"]["app_secret"], {:scope => "user_about_me,publish_stream"}
  provider :browser_id, :name => "persona"
end

#uncomment to debug errors from omniauth
#OmniAuth.config.on_failure do |env|
  #[200, {}, [env['omniauth.error'].to_yaml]]
#end
