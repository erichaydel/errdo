Errdo::Engine.routes.draw do
  resources :errors, only: [:index]

  root to: "errors#index"
end
