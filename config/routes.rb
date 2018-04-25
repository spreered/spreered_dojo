Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'posts#index'

  resources :posts
  resources :user, only:[:show, :edit, :update]
  namespace :admin do 
    root "categories#index"
    resources :categories
    resources :users
  end
end
