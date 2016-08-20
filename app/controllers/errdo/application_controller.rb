module Errdo
  class ApplicationController < ::ApplicationController

    before_action :_authenticate!

    private

    def _authenticate!
      instance_eval(&Errdo.authenticate_with)
    end

  end
end
