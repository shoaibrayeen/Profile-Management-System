Rails.application.routes.draw do

  get 'admins/signin'

  get 'admins/signup'

  #get 'admins/search_result'

  get 'users/logout'

  get 'admins/view'

  get 'users/sigin'
  post 'users/sigin'

  get 'admins/search' 
  post 'admins/search' => 'admins#search_result'
  get 'admins/report'

  #mount RailsAdmin::Engine => '/admin1', as: 'rails_admin'

  ##get 'users/index'
  root 'users#sigin'

  #patch '/admins/updateData' => 'admins#updateData'
  ##get 'users/signin' => 'users#signin'
  #post 'users/signin' => 'users#sign'
  #post 'users' => 'users#signin'
  resources :users, only: [:new, :create, :edit, :update, :show, :index]
  resources :admins
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
