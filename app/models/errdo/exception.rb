module Errdo
  class Exception

    def initialize(env)
      unless Errdo.error_name.blank?
        @parser = Errdo::Models::ErrorEnvParser.new(env)
        create_errors(@parser)
      end
    end

    private

    def create_errors(parser)
      Errdo::Error.create(parser.error_hash)
      Errdo::ErrorOccurrence.create(parser.error_occurrence_hash)
    end

  end
end
