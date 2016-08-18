Errdo::Engine.routes.draw do
  resources :errors, only: [:show]

  root to: "errors#index"
end
