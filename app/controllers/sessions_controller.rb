class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    
    if session[:admin_facebook] 
      yaml = YAML.load_file("#{RAILS_ROOT}/config/application.yml")
      session[:admin_facebook] = false
      
      pages = FGraph.me_accounts(:access_token => auth["credentials"]["token"])

      pages.each do |i|
        if i["name"] == yaml[RAILS_ENV]["facebook"]["page_name"] && i["category"] == "Website" then
          yaml[RAILS_ENV]["facebook"]["page_access_token"] = i["access_token"];

          output = File.new("#{RAILS_ROOT}/config/application.yml", "w")
          output.puts YAML.dump(yaml)
          output.close
          
          render :text => (RAILS_ENV + " access token updated: " + i["access_token"])
          return
        end
      end
      
      render :text => "Unable to find access token for " + yaml[RAILS_ENV]["facebook"]["page_name"]
      return
    end
    
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) 
    if user && user.provider == "twitter"
      # update their twitter access token
      user.token = auth["credentials"]["token"]
      user.secret = auth["credentials"]["secret"]
      user.save!
    elsif !user
      user = User.create_with_omniauth(auth)
    end
    session[:user_id] = user.id
    if session[:joke_id]      
      redirect_to(url_for(:action => "show", :controller => "jokes", :id => session[:joke_id], :only_path => false), :notice => "Signed in with #{auth["provider"].capitalize}!")
    else
      redirect_to root_url, :notice => "Signed in with #{auth["provider"].capitalize}!"
    end
    #uncomment to see what's all in the auth
    #render :text => auth.to_yaml
  end
  
  def admin_authenicate
    session[:admin_facebook] = true
    redirect_to '/auth/facebook'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
  
  def failure
    redirect_to root_url, :notice => "Sorry, something went wrong with authentication."
  end
  
  def full_version
    session[:mobile_view] = false
    
    redirect_to root_url
  end
  
  def mobile_version
    session[:mobile_view] = true
    
    redirect_to root_url
  end
end