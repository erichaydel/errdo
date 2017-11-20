require "slim"

module Errdo
  class ErrorsController < Errdo::ApplicationController

    include Errdo::Helpers::ViewsHelper
    helper_method :user_show_string, :user_show_path

    before_action :authorize_user

    DEFAULT_SCOPE = "active"

    def index
      @scope = get_whitelisted_scope

      if @scope == "all"
        base_query = Errdo::Error
      else
        base_query = Errdo::Error.send(@scope)
      end

      @errors = base_query.order(last_occurred_at: :desc)
                          .includes(:last_experiencer)
                          .page(params[:page])

      @chart_data = {
        errors:      Error.grouped_by_time(2.weeks),
        occurrences: ErrorOccurrence.grouped_by_time(2.weeks)
      }
    end

    def show
      @error = Errdo::Error.find(params[:id])
      @occurrence, @index, @total = selected_occurrence(@error)
    end

    def update
      @error = Errdo::Error.find(params[:id])
      if @error.update(error_params)
        flash[:notice] = "Success updating status!"
      else
        flash[:alert] = "Updating failed"
      end
      @occurrence, @index, @total = selected_occurrence(@error)
      render :show
    end

    private

    def authorize_user
      @authorization_adapter ||= nil
      @authorization_adapter.try(:authorize, params["action"], Errdo::Error)
    end

    def error_params
      params.require(:error).permit(:status)
    end

    def selected_occurrence(error)
      occurrences = error.error_occurrences.order(created_at: :desc)
      if params[:occurrence_id]
        id = occurrences.find { |o| o.id == params[:occurrence_id] }
        return occurrences[id], id, occurrences.length
      elsif params[:occurrence_index]
        return occurrences[params[:occurrence_index].to_i], params[:occurrence_index].to_i, occurrences.length
      else
        return occurrences.last, 0, occurrences.length
      end
    end

    def get_whitelisted_scope
      if params[:scope] == "active"
        "active"
      elsif params[:scope] == "resolved"
        "resolved"
      elsif params[:scope] == "wontfix"
        "wontfix"
      elsif params[:scope] == "all"
        "all"
      else
        DEFAULT_SCOPE
      end
    end

  end
end
