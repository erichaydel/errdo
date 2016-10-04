module Errdo
  class Exception

    def initialize(env)
      user_parser = Errdo::Models::UserParser.new(env)
      @env_parser = Errdo::Models::ErrorEnvParser.new(env, user_parser)
      create_errors(@env_parser) unless Errdo.error_name.blank?
      Errdo.notify_with.each do |notifier|
        notifier.notify(@env_parser)
      end
    end

    private

    def create_errors(parser)
      error = Errdo::Error.find_or_create(parser.error_hash)
      error.try(:error_occurrences).try(:create, parser.error_occurrence_hash)
    end

  end
end
