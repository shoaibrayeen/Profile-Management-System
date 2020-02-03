=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Routes for the whole app   
=end

Rails.application.routes.draw do

  require 'sidekiq/web'
	require 'sidekiq/cron/web'
	mount Sidekiq::Web => '/sidekiq'

  get 'adminusers/signup'
  post 'adminusers/signup'

  get 'admin/index'

  get 'admin/signup'
  post 'admin/signup'

  get 'admin/signin'
  post 'admin/signin'

  get 'admin/signout'

  get 'admin/search'
  post 'admin/search'   => 'admin#search_result'

  get 'admin/report'

  get 'users/signin'
  post 'users/signin'
  get 'users/signup'
  post 'users/signup'
  get 'users/signout'

  root 'users#signin'

  get 'admin' => 'admin#signin'

  post 'adminusers/:id/edit' => 'adminusers#update'

  post 'users/:id/edit' => 'users#update'
  resources :users, only: [:edit, :update, :show, :index]
  resources :adminusers, only: [:edit, :update, :show, :index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
