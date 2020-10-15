Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root to: 'posts#index'

  resources :posts
  devise_for :users
  resources :likes, only: [:create, :destroy]
  get 'about', to: 'application#about'
end
