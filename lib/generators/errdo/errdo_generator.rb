require 'rails/generators/named_base'

module Errdo
  module Generators
    class ErrdoGenerator < Rails::Generators::NamedBase

      desc "Creates the database objects for error logging"

      include Rails::Generators::ResourceHelpers
      namespace "errdo"

      argument :name, type: 'string', default: "error"

      hook_for :orm do |instance, controller|
        instance.invoke controller, [instance.name]
      end

      def add_error_name_to_initializer
        inject_into_file 'config/initializers/errdo.rb', before: "\nend" do
          <<-TEXT


    # This is the name of the class inside your application that the exceptions are stored as.
    # Exceptions are a reserved class name.
    #
    # If you want to rename it, make sure you also change the migration that comes with the gem.
    # Setting this to nil means that errors won't be tracked in the database
    # Note: The model name "{name}_instance" should also be free
    #
    # Installing with the option --no-database should set this correctly
    config.error_name = :#{file_name}
          TEXT
        end
      end

    end
  end
end
