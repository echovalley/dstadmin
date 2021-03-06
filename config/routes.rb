Dstadmin::Application.routes.draw do

  resources :products, :path => 'advertiser/products' do
    collection do
      get 'search'
      post 'batch_destroy'
      post 'batch_update_status'
      post 'batch_update_tags'
    end
    member do
      get 'update_status'
      put 'upload_avatar'
      get 'statistics'
    end
  end

  resources :websites, :path => 'media/websites' do
    member do
      get 'verify' => 'websites#pre_verify', :as => 'verify'
      get 'create_verify_file'
      post 'verify' => 'websites#verify', :as => 'verify_process'
      delete 'destroy' => 'websites#destroy', :as => 'destroy'
      get 'code' => 'websites#code', :as => 'code'
    end
    resources :tagged_images do
      collection do
        get 'search'
      end
      member do
        get 'statistics_tagged_image'
        get 'statistics_spots'
        get 'update_title'
        get 'show_image'
      end
    end
    resources :untagged_images do
      collection do
        get 'search'
      end
    end
  end

  resources :users do
    collection do
      get 'signup'
      get 'check_email'
      post 'signup' => 'users#signup_submit'
      get 'activate'
      get 'send_activation_email' => 'users#send_activation_email', :as => 'send_activation_email'
      post 'send_activation_email' => 'users#post_activation_email', :as => 'post_activation_email'
      get 'signup_adv' => 'users#signup_adv'
      post 'signup_adv' => 'users#signup_adv_submit'
      get 'signin' => 'users#signin'
      post 'signin' => 'users#authenticate', :as => 'authenticate'
      get 'signout' => 'users#signout'
      get 'forgetpwd' => 'users#forget_password', :as => 'forget_password'
      put 'forgetpwd' => 'users#reset_password', :as => 'reset_password'
    end
    member do
      get 'changepwd' => 'users#change_password', :as => 'change_password'
      put 'changepwd' => 'users#update_password', :as => 'update_password'
    end
  end

  resources :advertisers do
  end


  match "/advertiser/dashboard" => "advertisers#dashboard", :as => 'dashboard_advertiser', :via => :get
  match "/common/refresh_captcha" => "application#refresh_captcha", :as => 'refresh_captcha', :via => :get
  match "/common/error" => "application#error", :as => 'error', :via => :get


  get "home/index"
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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
