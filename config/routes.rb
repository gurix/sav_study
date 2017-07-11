Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'pages#index'
  resources :pages, param: :page
  resources :newsletters
  resources :subjects do
    resource :car
    resources :routes
    resource :present_profile, only: :show
    resource :future_profile, only: :show
    resource :questionary
  end
end
