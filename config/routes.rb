Errdo::Engine.routes.draw do
  resources :errors, only: [:show, :update]

  root to: "errors#index"
end
