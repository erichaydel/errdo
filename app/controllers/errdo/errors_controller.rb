require "slim"

module Errdo
  class ErrorsController < ApplicationController

    def index
      @errors = Errdo::Error.order(last_occurred_at: :desc).page params[:page]
    end

    def show
      @error = Errdo::Error.find(params[:id])
      @occurrence = selected_occurrence(@error)
    end

    private

    def selected_occurrence(error)
      if params[:occurrence_id]
        Errdo::ErrorOccurrence.find(params[:occurrence_id])
      else
        error.error_occurrences.last
      end
    end

  end
end
