Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get 'welcome/index'

  Rails.application.routes.draw do
    get "/pages/:page" => "pages#show"
  end

  resources :activities, only: [:index, :show, :new, :create] do
    patch :participate, on: :member
    post :finish, on: :member
  end
  resources :welcome, only: [:index]

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
