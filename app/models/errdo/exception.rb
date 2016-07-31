module Errdo
  class Exception

    def initialize(env)
      unless Errdo.error_name.nil?
        @parser = Errdo::Models::ErrorEnvParser.new(env)
        Errdo::Error.create(@parser.error_hash)
        Errdo::ErrorOccurrence.create(@parser.error_occurrence_hash)
      end
    end

  end
end
