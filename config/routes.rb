Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication routes
  post '/auth/login', to: 'authentication#authenticate'
  post '/signup', to: 'users#create'
  
  # API Documentation
  get '/docs', to: 'api_docs#index'
  
  # Todo routes
  resources :todos, except: [:new, :edit]
  
  # API versioning (optional for future expansion)
  namespace :api do
    namespace :v1 do
      resources :todos, except: [:new, :edit]
    end
  end

  # Defines the root path route ("/")
  root "rails/health#show"
end
