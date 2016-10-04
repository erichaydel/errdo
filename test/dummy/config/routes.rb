Rails.application.routes.draw do
  devise_for :users
  get 'static/home'
  get 'static/generic_error'
  get 'static/long_error'
  get 'static/log'

  resources :users

  mount Errdo::Engine => "/errdo"

  root to: "static#home"
end
