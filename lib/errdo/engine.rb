require 'chartkick'

module Errdo
  class Engine < Rails::Engine

    isolate_namespace Errdo

    require "kaminari"

    config.autoload_paths += %W[#{config.root}/lib]

    config.before_initialize do |app|
      app.config.exceptions_app = Errdo::ExceptionsController.new(Rails.public_path)
    end

    initializer 'Errdo precompile hook', group: :all do |app|
      app.config.assets.precompile += %w[errdo/errdo.css errdo/errdo.js errdo/logo.png]
    end

  end
end
