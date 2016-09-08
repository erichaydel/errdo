module Errdo
  module Models
    class SlackMessager

      include Errdo::Helpers::ViewsHelper # For the naming of the user in the message

      def initialize(error, parser)
        if error.nil?
          @user = parser.user
          @backtrace = parser.short_backtrace
          @exception_name = parser.exception_name
          @exception_message = parser.exception_message
        else
          @user = error.last_experiencer
          @backtrace = error.short_backtrace
          @exception_name = error.exception_class_name
          @exception_message = error.exception_message
        end
      end

      def message
        "#{exception_string}#{user_message_addon}\n#{@backtrace}"
      end

      private

      def exception_string
        "#{@exception_name} | #{@exception_message}"
      end

      def user_message_addon
        "\nExperienced by #{user_show_string(@user)} " if @user
      end

    end
  end
end
