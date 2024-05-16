Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :cart, only: %i[show destroy]

  resources :line_items, only: %i[create destroy]
  resources :orders, except: %i[edit update]

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "products#index"
end
