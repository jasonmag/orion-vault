Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: "admins/sessions",
    registrations: "admins/registrations"
  }
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  authenticate :admin do
    scope :admin, module: :admins, as: :admin do
      get "dashboard", to: "dashboard#index"
      root to: "dashboard#index"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get "about" => "pages#about"

  # Defines the root path route ("/")
  # root "posts#index"
  root "pages#home"

  resources :lists do
    get "frequency", on: :collection
    get "select_dates", on: :collection
    resources :check_list_histories, only: [ :create ]
  end

  get "insights" => "insights#index"
  resources :expenses, only: [ :index, :create, :edit, :update, :destroy ]

  resource :user_setting, only: [ :show, :edit ] do
    post :update, on: :collection
  end

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      devise_for :users, path: "auth", controllers: {
        sessions: "api/v1/auth/sessions",
        registrations: "api/v1/auth/registrations"
      }, path_names: { sign_in: "sign_in", sign_out: "sign_out", registration: "sign_up" },
      skip: [ :passwords, :confirmations, :unlock, :omniauth_callbacks ]

      resources :lists do
        get "frequency", on: :collection
        resources :check_list_histories, only: [ :create ]
      end

      resources :expenses, only: [ :index, :create, :update, :destroy ]
      resource :user_setting, only: [ :show, :update ]
      get "insights" => "insights#index"
    end
  end

  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"
end
