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

    end
  end
end
