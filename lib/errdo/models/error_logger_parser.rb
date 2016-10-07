module Errdo
  module Models
    class ErrorLoggerParser

      attr_accessor :user, :exception_class_name, :exception_message, :http_method,
                    :host_name, :url, :backtrace, :ip, :user_agent, :referer,
                    :query_string, :param_values, :cookie_values, :header_values,
                    :experiencer_id, :experiencer_type

      def initialize(exception, message_string, params)
        set_accessible_params(
          exception,
          message_string,
          params
        )
      end

      def error_hash
        {
          exception_class_name:   @exception_class_name,
          exception_message:      @exception_message,
          backtrace:              @backtrace,
          last_experiencer_id:    @experiencer_id,
          last_experiencer_type:  @experiencer_type
        }
      end

      def error_occurrence_hash
        {
          param_values:         @param_values,
          experiencer_id:       @experiencer_id,
          experiencer_type:     @experiencer_type
        }
      end

      def exception_name
        @exception_class_name
      end

      def short_backtrace
        @backtrace.first if @backtrace.respond_to?(:first)
      end

      private

      def set_accessible_params(exception, message_string, params)
        @exception_class_name = exception.present? ? exception.class.to_s : "None"
        @exception_message =    message_string || exception.try(:message)
        @backtrace =            prepare_backtrace(exception)
        @param_values =         scrubbed_params(params)
        @experiencer_id =       params.try(:[], :user).try(:id)
        @experiencer_type =     params.try(:[], :user).try(:class).try(:name)
      end

      def prepare_backtrace(exception)
        exception.try(:backtrace) || caller.reject { |n| n =~ %r{\/lib\/errdo} } # Default to showing the call stack
      end

      def scrubbed_params(params)
        return if params.nil?
        params = params.with_indifferent_access
        Errdo.dirty_words.each do |word|
          params[word] = "..." if params[word]
        end
        params.symbolize_keys
      end

    end
  end
end
