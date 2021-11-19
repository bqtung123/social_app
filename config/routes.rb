Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destroy'
  root 'static_pages#home'
  get 'help' =>'static_pages#help'
  get 'about' =>'static_pages#about'

  get 'signup' => 'users#new'
  resources :users

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :users do
     member do
      get :following,:followers
     end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new,:create,:edit,:update]
  resources :microposts, only: [:create,:destroy]
  resources :relationships, only: [:create,:destroy]

  get '/auth/:provider/callback', to: 'sessions#redirect_callback'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
