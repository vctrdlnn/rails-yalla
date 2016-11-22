Rails.application.routes.draw do

  scope '(:locale)', locale: /en|fr|de/ do
    root to: 'pages#home'
    devise_for :users do
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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
