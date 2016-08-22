module Errdo
  module Helpers
    module ViewsHelper
      def user_show_string(user)
        if user.respond_to?(Errdo.user_string_method || "")
          user.send(Errdo.user_string_method)
        elsif user
          user.class.to_s + " #" + user.id.to_s
        else
          ""
        end
      end

      def user_show_path(user)
        if Errdo.user_show_path && user
          Rails.application.routes.url_helpers.send(Errdo.user_show_path, user)
        else
          errdo.root_path
        end
      end
    end
  end
end
