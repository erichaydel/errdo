module Errdo
  module Extensions
    module CanCanCan
      # This adapter is for the CanCanCan[https://github.com/CanCanCommunity/cancancan] authorization library.
      class AuthorizationAdapter

        # See the +authorize_with+ config method for where the initialization happens.
        def initialize(controller, ability = ::Ability)
          @controller = controller
          @controller.instance_variable_set '@ability', ability
          @controller.extend ControllerExtension
        end

        # This method is called in every controller action and should raise an exception
        # when the authorization fails. The first argument is the name of the controller
        # action as a symbol (:create, :bulk_delete, etc.). The second argument is the
        # object to check
        def authorize(action, object)
          # binding.pry
          @controller.current_ability.authorize!(action, object) if action
        end

        # This method is called primarily from the view to determine whether the given user
        # has access to perform the action on a given model. It should return true when authorized.
        # This takes the same arguments as +authorize+. The difference is that this will
        # return a boolean whereas +authorize+ will raise an exception when not authorized.
        def authorized?(action, object)
          @controller.current_ability.can?(action, object) if action
        end

        module ControllerExtension
          def current_ability
            # use _current_user instead of default current_user so it works with
            # whatever current user method is defined with Errdo
            @current_ability ||= @ability.new(_current_user)
          end
        end

      end
    end
  end
end
