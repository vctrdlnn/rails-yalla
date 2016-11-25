Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  scope '(:locale)', locale: /en|fr|de/ do
    root to: 'pages#home'
    devise_for :users, skip: [:omniauth_callbacks, :registrations] do
      member do
        get 'profile'
      end
    end

    resources :trips do
      resources :activities
      resources :trip_days, only: [:create, :destroy, :update, :show]
      member do
        put 'like'
        get 'print'
      end
    end

    resources :activities do
      member do
        put 'pin'
        put 'change_position'
      end
    end
  end

  devise_for :users, only: [:omniauth_callbacks, :registrations], controllers: {omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations'}
end


