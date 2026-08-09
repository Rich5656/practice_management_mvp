Rails.application.routes.draw do
  # get "clients/index"
  # get "clients/show"
  # get "clients/new"
  # get "clients/edit"
  get "dashboard/show"
  get "sign_ups/new"
  get "sign_ups/create"
  resource :session
  resources :passwords, param: :token
  
  resource :sign_up, only: [:new, :create], controller: "sign_ups"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  get "/sign_up", to: "sign_ups#new"
  post "/sign_up", to: "sign_ups#create"

  resources :clients

  root "dashboard#show"  

  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
