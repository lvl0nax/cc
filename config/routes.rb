TestMongoid::Application.routes.draw do
  mount TinymceFm::Engine => "/tinymce_fm"
  resources :months

  resources :areas do
    collection do
      post 'add_to_user'
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
    end
  end

  resources :resumes

  resources :compinfos

  resources :pages


  devise_for :users, :controllers => { 
    :registrations => "registrations",
    :sessions => "sessions"
  } do
    resources :resumes
    resources :compinfos
  end

  get "/profile" => "users#show"

  #devise_for :users do
  #  get "/activities" => "devise/registrations#activities"
  #end
  #get "/:id/activities" => "users#activities"


  resources :users do #, :only => [:show, :index, :activities ]
    member do
      get "activities"
      get "userevents"
    end
  end

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
