module Errdo
  class ErrorOccurrence < ActiveRecord::Base

    self.table_name = "#{Errdo.error_name.to_s.singularize}_occurrences"

    serialize :param_values
    serialize :cookie_values
    serialize :header_values

    belongs_to :error, counter_cache: :occurrence_count
    belongs_to :experiencer, polymorphic: true

    after_create :update_last_occurrence
    after_create :update_last_experiencer

    def self.grouped_by_time(timeframe = nil)
      errors = Errdo::ErrorOccurrence.where("created_at > ?", 2.weeks.ago)
      timeframe = useful_time(Time.now - errors.first.created_at) if timeframe.nil?
      hist(errors, 24, Time.now - timeframe, timeframe)
    end

    private

    def update_last_occurrence
      error.update(last_occurred_at: created_at) if error && !created_at.nil?
    end

    def update_last_experiencer
      error.update(last_experiencer: experiencer) if error
    end

  end
end
