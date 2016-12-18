Rails.application.routes.draw do
  devise_for :users
  get 'static/home'
  get 'static/generic_error'
  get 'static/long_error'
  get 'static/log'
  get 'static/view_error'

  resources :users

  mount Errdo::Engine => "/errdo"

  root to: "static#home"
end
