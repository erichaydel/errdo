require 'rails/generators/base'

module Errdo
  module Generators
    class ErrdoGenerator < Rails::Generators::Base

      include Rails::Generators::ResourceHelpers
      namespace "errdo"

      argument :name, type: 'string', default: "error", required: false

      hook_for :orm

    end
  end
end
