class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
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
    uncomment to see what's all in the auth
    render :text => auth.to_yaml
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
  
  def failure
    redirect_to root_url, :notice => "Sorry, something went wrong with authentication."
  end
end