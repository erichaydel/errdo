module Errdo
  class ApplicationController < ::ApplicationController

    before_action :_authenticate!
    before_action :_authorize!

    def _current_user
      instance_eval(&Errdo.current_user_method)
    end

    private

    def _authenticate!
      instance_eval(&Errdo.authenticate_with)
    end

    def _authorize!
      instance_eval(&Errdo.authorize_with)
    end

  end
end
