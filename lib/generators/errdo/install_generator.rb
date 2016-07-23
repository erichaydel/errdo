require 'rails/generators/base'

module Errdo

  module Generators

    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates an errdo initializer and sets the exceptions_app to errdo's"

      def set_exceptions_app
        inject_into_file 'config/application.rb', before: "  end" do
          "\n    config.exceptions_app = Errdo::ExceptionsApp\n\n"
        end
      end

      def copy_initializer
        template "errdo.rb", "config/initializers/errdo.rb"
      end

    end

  end

end
