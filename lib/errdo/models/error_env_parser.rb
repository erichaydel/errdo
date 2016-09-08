module Errdo
  module Models
    class ErrorEnvParser

      attr_accessor :user

      def initialize(env, user_parser)
        @env = env
        @request = ActionDispatch::Request.new(env)
        @controller = @env["action_controller.instance"]
        @user = user_parser.user
      end

      def error_hash
        {
          exception_class_name: @env["action_dispatch.exception"].class.to_s,
          exception_message:    @env["action_dispatch.exception"].try(:message),
          http_method:          @request.try(:request_method),
          host_name:            @request.try(:server_name),
          url:                  @request.try(:original_url),
          backtrace:            prepare_backtrace(@env)
        }
      end

      def error_occurrence_hash
        {
          ip:                   @request.try(:ip),
          user_agent:           @request.try(:user_agent),
          referer:              @request.try(:referer),
          query_string:         @request.try(:query_string),
          param_values:         scrubbed_params(@request),
          cookie_values:        @request.try(:cookies),
          header_values:        @controller.try(:headers),
          experiencer_id:       @user.try(:id),
          experiencer_type:     @user.try(:class).try(:name)
        }
      end

      def exception_name
        @env["action_dispatch.exception"].class.to_s
      end

      def exception_message
        @env["action_dispatch.exception"].try(:message)
      end

      def backtrace
        prepare_backtrace(@env)
      end

      def short_backtrace
        backtrace.first if backtrace.respond_to?(:first)
      end

      private

      def dirty_words
        %w(password passwd password_confirmation secret confirm_password secret_token)
      end

      def prepare_backtrace(env)
        env["action_dispatch.exception"].try(:backtrace)
      end

      def scrubbed_params(request)
        params = request.try(:params)
        dirty_words.each do |word|
          params[word] = "..." if params[word]
        end
        params
      end

    end
  end
end
