Rails.application.routes.draw do
  get "slack/callback"
  root "static_pages#home"
  get "help" => "static_pages#help"
  get "about" => "static_pages#about"

  # get "signup" => "users#new"
  # resources :users
  #User
  devise_for :users,
             controllers: {
               sessions: "users/sessions",
               registrations: "users/registrations",
               passwords: "users/passwords",
               confirmations: "users/confirmations",
               omniauth_callbacks: "users/omniauth_callbacks"
             }

  devise_scope :user do
    get "login", to: "users/sessions#new"
    get "signup", to: "users/registrations#new"
    delete "logout", to: "users/sessions#destroy"
  end

  # get "login" => "sessions#new"
  # post "login" => "sessions#create"
  # delete "logout" => "sessions#destroy"
  resources :users do
    member { get :following, :followers, :chat }
  end

  # resources :account_activations, only: [:edit]
  # resources :password_resets, only: [:new,:create,:edit,:update]
  resources :comments do
    member { put "likes" => "comments#vote" }
  end
  resources :microposts do
    resources :comments
    member { put "likes" => "microposts#vote" }
  end

  resources :rooms do
    resources :messages
  end

  resources :relationships, only: %i(create destroy)

  get "/auth/:provider/callback", to: "sessions#redirect_callback"
  get "/auth/callback", to: "slack#callback"
  post "post_message", to: "slack#post_message"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
