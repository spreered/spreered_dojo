Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'posts#index'

  resources :posts do
    resources :comments, only:[:create,:edit,:update,:destroy]
    member do 
      post :collect
      post :uncollect
    end
  end
  resources :users, only:[:show, :edit, :update] do
    member do
     get :post
     get :collect
     get :comment
     get :draft
     get :friend
   end
  end
  namespace :admin do 
    root "categories#index"
    resources :categories
    resources :users
  end
end
