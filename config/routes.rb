Rails.application.routes.draw do

  scope '(:locale)', locale: /en|fr|de/ do
    root to: 'pages#home'
    devise_for :users, skip: :omniauth_callbacks,
      controllers: {
        registrations: "registrations"
      } do
      get 'profile'
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
      end
    end
  end

  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
end


