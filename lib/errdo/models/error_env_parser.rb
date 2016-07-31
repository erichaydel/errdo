module Errdo
  module Models
    class ErrorEnvParser

      def initialize(env)
        @env = env
        @request = ActionDispatch::Request.new(env)
        @controller = @env["action_controller.instance"]
        # binding.pry
      end

      def error_hash
        {
          exception_class_name: @env["action_dispatch.exception"].class.to_s,
          exception_message:    @env["action_dispatch.exception"].try(:message),
          http_method:          @request.try(:request_method),
          host_name:            @request.try(:server_name),
          url:                  @request.try(:url),
          backtrace:            prepare_backtrace(@env)
        }
      end

      def error_occurrence_hash
        {
          ip:                   @request.try(:ip),
          user_agent:           @request.try(:user_agent),
          referer:              @request.try(:referer),
          query_string:         @request.try(:query_string),
          param_values:         sanitized_params(@request),
          cookie_values:        @request.try(:cookies).try(:inspect),
          header_values:        @controller.try(:headers)
        }
      end

      private

      def prepare_backtrace(env)
        env["action_dispatch.exception"].try(:backtrace)
      end

      def sanitized_params(request)
        params = request.try(:params)
        params["password"] = "..." if params["password"]
        params.try(:inspect)
      end

    end
  end
end
