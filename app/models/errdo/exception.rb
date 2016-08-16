module Errdo
  class Exception

    def initialize(env, current_user)
      unless Errdo.error_name.blank?
        @parser = Errdo::Models::ErrorEnvParser.new(env, current_user)
        create_errors(@parser)
      end
    end

    private

    def create_errors(parser)
      error = Errdo::Error.find_or_create(parser.error_hash)
      error.try(:error_occurrences).try(:create, parser.error_occurrence_hash)
    end

  end
end
