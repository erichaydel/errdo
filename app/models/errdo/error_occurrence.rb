module Errdo
  class ErrorOccurrence < ActiveRecord::Base

    self.table_name = "#{Errdo.error_name.to_s.singularize}_occurrences"

    serialize :param_values
    serialize :cookie_values
    serialize :header_values

    belongs_to :error, counter_cache: :occurrence_count

    after_create :update_last_occurrence

    def experiencer
      experiencer_class.constantize.find(experiencer_id) if experiencer_class
    end

    private

    def update_last_occurrence
      error.update(last_occurred_at: created_at) if error
    end

  end
end
