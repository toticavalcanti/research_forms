Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :forms
      resources :questions, only: [:create, :update, :destroy]
      resources :answers, only: [:index, :show, :create, :destroy]
    end
  end
end
