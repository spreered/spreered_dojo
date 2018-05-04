Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'posts#index'
  get '/feeds' => 'posts#feeds', as: 'feeds'
  resources :posts do
    resources :comments, only:[:create,:edit,:update,:destroy]
    member do 
      post :collect
      post :uncollect
    end
  end
  resources :categories, only:[:show]
  resources :users, only:[:show, :edit, :update] do
    member do
     get :post_page
     get :collect_page
     get :comment_page
     get :draft_page
     get :friend_page
     post :invite_friendship
     post :cancel_inviting
     post :unfriend
     post :accept_frienship
     post :ignore_frienship
    end
  end
  namespace :admin do 
    root "categories#index"
    resources :categories
    resources :users
  end
end
