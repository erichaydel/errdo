Errdo::Engine.routes.draw do
  resources :errors, only: [:index, :show]

  root to: "errors#index"
end
