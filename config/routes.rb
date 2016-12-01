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
      resources :trip_days, only: [:create, :destroy, :update, :show]
      resources :activities, only: [:create]
      member do
        put 'like'
        get 'print'
        put 'make_my_day'
        get 'map_markers', format: :json
        get 'properties'
      end
    end

    get 'my_trips', to: 'trips#my_trips'

    # get 'activities/new_act', to: 'activities#new_act'
    # post 'activities/new_act', to: 'activities#create'

    resources :activities do
      member do
        put 'pin'
        put 'change_position'
      end
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :trips, only: [ :index, :show ]
    end
  end

  devise_for :users, only: [:omniauth_callbacks, :registrations], controllers: {omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations'}
end
