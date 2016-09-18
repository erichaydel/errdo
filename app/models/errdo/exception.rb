module Errdo
  class Exception

    def initialize(env)
      user_parser = Errdo::Models::UserParser.new(env)
      @env_parser = Errdo::Models::ErrorEnvParser.new(env, user_parser)
      error = create_errors(@env_parser) unless Errdo.error_name.blank?
      send_slack_notification(error, @env_parser)
    end

    private

    def create_errors(parser)
      error = Errdo::Error.find_or_create(parser.error_hash)
      error.try(:error_occurrences).try(:create, parser.error_occurrence_hash)
      return error
    end

    def send_slack_notification(error, parser)
      if Errdo.slack_notifier
        messager = Errdo::Models::SlackMessager.new(error, parser)
        begin
          Errdo.slack_notifier.ping messager.message
        rescue => e
          Rails.logger.error e
        end
      end
    end

  end
end
