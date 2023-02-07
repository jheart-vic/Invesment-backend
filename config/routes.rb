Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  resources :users do
    collection do
      post 'verification_code' => 'user_token#create'
    end
  end
  resources :transactions

  devise_scope :user do
    get '/confirmation_success', to: 'confirmations#success'
  end
  get 'confirmations/:confirmation_token', to: 'confirmations#show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
