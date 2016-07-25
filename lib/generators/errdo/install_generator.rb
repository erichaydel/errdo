require 'rails/generators/base'

module Errdo
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates an errdo initializer and sets the exceptions_app to errdo's"

      def copy_initializer
        template "errdo.rb", "config/initializers/errdo.rb"
      end

    end
  end
end
