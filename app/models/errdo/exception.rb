module Errdo
  class Exception

    def initialize(env)
      user_parser = Errdo::Models::UserParser.new(env)
      unless Errdo.error_name.blank?
        @env_parser = Errdo::Models::ErrorEnvParser.new(env, user_parser)
        create_errors(@env_parser)
      end
    end

    private

    def create_errors(parser)
      error = Errdo::Error.find_or_create(parser.error_hash)
      error.try(:error_occurrences).try(:create, parser.error_occurrence_hash)
    end

  end
end
