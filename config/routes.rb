Rails.application.routes.draw do

  get 'messages/new'

  get 'messages/create'

  get 'messages/destroy'

  get 'messages/edit'

  get 'messages/update'

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
      resources :activities, only: [:create] do
        put 'copy'
      end
      member do
        put 'like'
        get 'print'
        get 'send_trip'
        put 'make_my_day'
        get 'map_markers', format: :json
        get 'properties'
        get 'chatroom'
      end
      collection do
        get 'search', to: 'trips#search'
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

    resources :trip_days do
      member do
        put 'update_title'
      end
    end

    resources :participants, only: [:destroy]
    resources :invites, only: [:create, :destroy]

  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :trips, only: [ :index, :show ]
    end
  end

  devise_for :users, only: [:omniauth_callbacks, :registrations], controllers: {omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations'}
end
