require "slim"

module Errdo
  class ErrorsController < ApplicationController

    def index
      @errors = Errdo::Error.order(last_occurred_at: :desc).page params[:page]
    end

    def show
      @error = Errdo::Error.find(params[:id])
    end

  end
end
