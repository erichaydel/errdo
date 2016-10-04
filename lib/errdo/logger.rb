module Errdo
  class Logger

    include Errdo::Helpers::NotificationHelper

    def initialize(importance, *args)
      @importance = importance
      exception, string, params = separate_args(*args)
      @parser = Errdo::Models::ErrorLoggerParser.new(exception, string, params)
    end

    def log
      error = Errdo::Error.find_or_create(**@parser.error_hash, importance: @importance)
      error.try(:error_occurrences).try(:create, @parser.error_occurrence_hash)
    end

  end
end
