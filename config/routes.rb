Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  # get 'sessions/create'
  # get 'sessions/destroy'

  get 'welcome/index'

  # get 'auth/:provider/callback', to: 'sessions#create'
  # get 'auth/failure', to: redirect('/')
  # get 'signout', to: 'sessions#destroy', as: 'signout'

  # resources :sessions, only: [:create, :destroy]
  resources :activities, only: [:index, :show, :new] do
    patch :participate, on: :member
    post :finish, on: :member
  end
  resources :welcome, only: [:index]

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
