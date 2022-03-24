Rails.application.routes.draw do
  
  root "static_pages#home"
  get "help" =>"static_pages#help"
  get "about" =>"static_pages#about"

  # get "signup" => "users#new"
  # resources :users
#User 
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    omniauth_callbacks:"users/omniauth_callbacks"
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
    member do
    get :following,:followers
    end
  end
  # resources :account_activations, only: [:edit]
  # resources :password_resets, only: [:new,:create,:edit,:update]
  resources :comments do
    member do
      put "likes" => "comments#vote"
    end
  end
  resources :microposts do
    resources :comments
    member do
      put "likes" => "microposts#vote"
    end
  end
  resources :relationships, only: [:create,:destroy]

  get "/auth/:provider/callback", to: "sessions#redirect_callback"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
