Rails.application.routes.draw do
  get 'static/home'
  get 'static/generic_error'
  get 'static/long_error'

  mount Errdo::Engine => "/errdo"

  root to: "static#home"
end
