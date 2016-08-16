module Errdo
  module Models
    class UserParser

      attr_accessor :user

      def initialize(env)
        # Warden support (This includes devise).
        if env['warden']
          user = app_user(env['warden'])
          return @user = user if user
        end

        controller = env["action_controller.instance"]
        if controller
          return @user = controller.send(Errdo.current_user_method) if Errdo.current_user_method
        end

        return nil
      end

      private

      def app_user(warden)
        scope = warden.config.default_scope
        user = warden.send(scope, run_callbacks: false) if scope.present?
        return user || nil
      end

    end
  end
end
