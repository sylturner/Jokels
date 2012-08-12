Jokels::Application.routes.draw do
  resources :jokes
  resources :users
  resources :tags
  match "/tag_search" => "tags#search"
  
  resources :jokes, :controller => "jokes" do
    get :upvote, :on => :member, :action => "upvote"
    get :downvote, :on => :member, :action => "downvote"
    get :favorite_toggle, :on => :member, :action => "favorite_toggle"
    get :sms_joke, :on => :member, :action => "new_sms_joke"
    post :sms_joke, :on => :member, :action => "send_sms_joke"
    get :add_tags, :on => :member, :action => "add_tags"
    post :save_tags, :on => :member, :action => "save_tags"
    post :is_kid_safe_toggle, :on => :member, :action => "is_kid_safe_toggle"
    get :embed, :on => :member, :action => "embed"
    get :show_min, :on => :member, :action => "embed"

    resources :alternate_punchlines, :controller => "alternate_punchlines" do
      get :upvote, :on => :member, :action => "upvote"
      get :downvote, :on => :member, :action => "downvote"
      post :is_kid_safe_toggle, :on => :member, :action => "is_kid_safe_toggle"
    end
  end

  resources :users, :controller => "users" do
    get :feed, :on => :member, :action => "feed"
    get :show, :on => :member, :action => "show"
  end
  
  resource :home, :controller => "home" do
    get :add_joke, :action => "add_joke"
    get :refresh_joke, :action => "index"
    get :privacy_policy, :action => "privacy_policy"
    get :clean_mode_on, :action => "clean_mode_on"
    get :clean_mode_off, :action => "clean_mode_off"
    get :kiosk_mode, :action => "kiosk_mode"
  end

  resource :admin, :controller => "admin" do
    get :joke_management, :action => "joke_management"
    get :index, :action => "index"
  end

  root :to => "home#index"
  
  match "/clean_mode_off" => "home#clean_mode_off"
  match "/clean_mode_on" => "home#clean_mode_on"
  match "/kiosk_mode" => "home#kiosk_mode"

  match "/qtip/joke" => "jokes#qtip"
  match "/qtip/user" => "users#qtip"

  match "/random_joke_path" => 'home#random_joke_path'
  
  match "/sms/receive" => 'jokes#receive_sms_request'
  
  match "/leaderboard" => "leaderboard#index"
  match "/leaderboard/:time/:sort/:sort_type" => "leaderboard#index"
  
  match '/feed' => 'jokes#feed', :as => :feed, :defaults => { :format => 'atom' }
  
  # omniauth stuff
  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure" => "sessions#failure"
  match "/signout" => "sessions#destroy", :as => :signout
  # uncommnent to update jokels page auth, also need to update omniauth.rb
  #match "/admin/facebook" => "sessions#admin_authenicate"
  
  match "/full_version" => "sessions#full_version"
  match "/mobile_version" => "sessions#mobile_version"
  
  # which tweet is from atlanta redirect
  match "/atl" => redirect("http://atl.jokels.com")
  
end
