Rails3BootstrapDeviseCancan::Application.routes.draw do
  namespace :admin do
    resources :locations, :wishes
  end

  resources :wishes do
    collection do
      post :confirm_wish
      get :order_wished_locations
      get :accept_match_request
      get :hand_shake_confirmation
      get :extend_expiry
      get :colloquial_confirmation
    end
  end

  resources :locations do
    collection do
      get :locations
      get :ordered_wishes
    end
  end

  root :to => "home#index"
  devise_for :users, :token_authentication_key => 'authentication_key', :controllers => {:registrations => "devise/registrations", :sessions => "devise/sessions"}
  devise_scope :user do
    get "/users/sign_out", to: "devise/sessions#destroy", :via => [:get, :post]
    get "/users/sign_in", to: "home#index", :via => [:get, :post]
  end
  resources :users
  namespace :admin do
    resources :wishes do
      get :approve, :cancel
    end
    resources :locations
  end


end