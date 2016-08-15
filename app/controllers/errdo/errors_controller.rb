require "slim"

module Errdo
  class ErrorsController < ApplicationController

    def index
      @errors = Errdo::Error.order(id: :desc).page params[:page]
    end

  end
end
