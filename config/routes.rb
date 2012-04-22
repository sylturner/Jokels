Jokels::Application.routes.draw do
  resources :jokes
  resources :users
  resources :tags
  
  resources :jokes, :controller => "jokes" do
    get :upvote, :on => :member, :action => "upvote"
    get :downvote, :on => :member, :action => "downvote"
    get :favorite_toggle, :on => :member, :action => "favorite_toggle"
    get :sms_joke, :on => :member, :action => "new_sms_joke"
    post :sms_joke, :on => :member, :action => "send_sms_joke"
    get :add_tags, :on => :member, :action => "add_tags"
    post :save_tags, :on => :member, :action => "save_tags"

    resources :alternate_punchlines, :controller => "alternate_punchlines" do
      get :upvote, :on => :member, :action => "upvote"
      get :downvote, :on => :member, :action => "downvote"
    end

  end
  
  resource :home, :controller => "home" do
    get :add_joke, :action => "add_joke"
    get :refresh_joke, :action => "index"
    get :privacy_policy, :action => "privacy_policy"
  end 

  root :to => "home#index"
  
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
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
