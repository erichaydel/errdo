Errdo::Engine.routes.draw do
  default_url_options host: Rails.application.config.action_mailer.default_url_options[:host]

  resources :errors, only: [:show, :update]

  root to: "errors#index"
end
