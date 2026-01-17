Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  # API routes
  namespace :api do
    get "health", to: "health#index"

    namespace :v1 do
      scope :ethereum, controller: :ethereum do
        post "transaction", action: :transaction
        post "block", action: :block
        post "balance", action: :balance
        post "block_number", action: :block_number
        post "call", action: :call
      end
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
