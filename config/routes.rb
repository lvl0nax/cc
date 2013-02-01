TestMongoid::Application.routes.draw do

  match '/auth/:provider/callback' => 'authentications#create'
  
  resources :authentications

  get "omniauth_callbacks/facebook"

  #get "omniauth_callbacks/vkontakte"

  mount TinymceFm::Engine => "/tinymce_fm"

  resource :images

  resources :months do
    collection do
      post 'update_calendar'
    end
  end

  resources :areas do
    collection do
      post 'add_to_user'
      get 'list'
      delete 'remove_from_user'

    end
  end

  resources :requests

  resources :trainings do
    member do
      get 'add_participant'
      get 'del_participant'
    end
  end

  resources :grants do
    member do
      get 'add_participant'
      get 'del_participant'
    end
  end  

  resources :events do
    member do
      get 'add_participant'
      get 'del_participant'
    end
    collection do
      get 'activities'
      get 'not_approved'
      post 'update_index'
      post 'event_status'
      post 'event_delete'
    end
  end

  resources :resumes do
    get 'crop', :on => :member
  end

  resources :compinfos do
    get 'crop', :on => :member
  end

  resources :pages


  devise_for :users, :controllers => { 
    :registrations => "registrations",
    :sessions => "sessions",
    :omniauth_callbacks => "users/omniauth_callbacks"
  } do
    get "sign_out", :to => "devise/sessions#destroy"
    resources :resumes
    resources :compinfos
  end

  post "valid" => "users#valid"
  post "add_remove_event" => "users#add_remove_event"
  get 'created_event' => "users#created_event"
  get 'send_mails'=> 'users#send_mails'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  get "/profile" => "users#show"

  #devise_for :users do
  #  get "/activities" => "devise/registrations#activities"
  #end
  #get "/:id/activities" => "users#activities"

  match "admin_page", :to => "users#admin_page", :as => :admin_page
  resources :users do #, :only => [:show, :index, :activities ]
    member do
      get "activities"
      get "userevents"      
      #get "admin_page"
    end
  end

  get "users/sphere", :as => 'sphere'

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
  root :to => 'events#index'

  #root :to => 'users'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
