module Errdo
  class Exception

    def initialize(env)
      user_parser = Errdo::Models::UserParser.new(env)
      @env_parser = Errdo::Models::ErrorEnvParser.new(env, user_parser)

      error = nil
      error = create_errors(@env_parser) unless Errdo.error_name.blank?
      unless too_soon? error
        Errdo.notify_with.each do |notifier|
          notifier.notify(@env_parser, error: error)
        end
      end
    end

    private

    def create_errors(parser)
      error = Errdo::Error.find_or_create(parser.error_hash)
      error.try(:error_occurrences).try(:create, parser.error_occurrence_hash)
      return error
    end

    def too_soon?(error)
      return false if error.nil?

      last_occurrence = error.error_occurrences.offset(1).order("created_at asc").last
      if last_occurrence && Errdo.ignore_time && last_occurrence.created_at > (Time.current - Errdo.ignore_time)
        return true
      end
      return false
    end

  end
end
