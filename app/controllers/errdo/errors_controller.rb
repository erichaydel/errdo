require "slim"

module Errdo
  class ErrorsController < ApplicationController

    def index
      @errors = Errdo::Error.all
    end

  end
end
