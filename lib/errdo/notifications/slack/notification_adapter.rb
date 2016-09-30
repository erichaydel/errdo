require 'slack-notifier'
require_relative '../../helpers/views_helper.rb'

module Errdo
  module Notifications
    module Slack
      # This adapter is for slack notifier
      class NotificationAdapter

        # See the slack notifier for where the initialization happens.
        def initialize(options = {})
          @slack_notifier = ::Slack::Notifier.new options[:webhook],
                                                  channel: options[:channel] || nil,
                                                  icon_emoji: options[:icon] || ':boom:',
                                                  username: options[:name] || 'Errdo-bot'
        end

        def notify(error, parser)
          messager = SlackMessager.new(error, parser)
          begin
            @slack_notifier.ping messager.message
          rescue => e
            Rails.logger.error e
          end
        end

      end

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
end
