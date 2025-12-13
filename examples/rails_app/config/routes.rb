Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    get "health", to: "health#index"
    
    namespace :v1 do
      # Converter endpoints
      namespace :converter do
        post :uppercase
        post :lowercase
        post :reverse
        post :title_case
        post :snake_case
        post :camel_case
      end
      
      # Ethereum endpoints
      namespace :ethereum do
        post :transaction
        post :receipt
        post :block_number
        post :call
      end
      
      # Debug endpoints
      namespace :debug do
        post :transaction
        post :receipt
      end
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
