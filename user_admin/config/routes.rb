Rails.application.routes.draw do
  get 'startup/signup'

  get 'startup/index'
  #root 'startup#index'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get 'users/index'
  root 'users#index'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
