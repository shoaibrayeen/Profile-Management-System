=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Routes for the whole app   
=end

Rails.application.routes.draw do

  get 'api/get_profile' => 'users_api#get_profile'
  post 'api/signup' => 'users_api#signup'
  post 'api/signin' => 'users_api#signin'
  get 'reports/index'
  post 'reports/index' => 'reports#result'

  #require 'sidekiq/web'
	#require 'sidekiq/cron/web'
	#mount Sidekiq::Web => '/sidekiq'

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

  get 'users/signin'
  post 'users/signin'
  get 'users/signup'
  post 'users/signup'
  get 'users/signout'

  root 'users#signin'

  get 'admin' => 'admin#signin'

  post 'adminusers/:id/edit' => 'adminusers#update'

  #post 'users/:id/edit' => 'users#update'
  #resources :users, only: [:show, :index]
  get 'users' => 'users#index'
  get 'user/:id' => 'users#show' , as: 'show'

  get 'user/:id/edit_bio' => 'users#edit_bio', as: 'edit_bio'
  post 'user/:id/edit_bio' => 'users#update_bio'

  get 'user/:id/change_password' => 'users#change_password', as: 'change_password'
  post 'user/:id/change_password' => 'users#update_password'

  resources :adminusers, only: [ :edit, :update, :show, :index]
  get 'adminuser/:id/change_password' => 'adminusers#change_password', as: 'adminuser_change_password'
  post 'adminuser/:id/change_password' => 'adminusers#update_password'

  get 'adminuser/:id/deactivate' => 'adminusers#deactivate', as: 'adminuser_deactivate'

  get 'adminuser/:id/add_parent' => 'adminusers#add_parent', as: 'adminuser_add_parent'
  post 'adminuser/:id/add_parent' => 'adminusers#update_parent'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
