Rails.application.routes.draw do
  get "users/show"
  # Replace individual book routes with resources
  resources :books, only: [ :index, :show ] do
    member do
      get :borrow
      post :create_borrowing
      get :return
      post :complete_return
    end
  end

  # Authentication routes
  resource :session
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes (commented out)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Root and dashboard routes
  root "pages#home"
  get "dashboard", to: "pages#dashboard"

  # User profile route
  resources :users, only: [ :show ]
end
