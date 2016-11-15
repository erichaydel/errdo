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

        def notify(parser, options = nil)
          messager = SlackMessager.new(parser, options)
          begin
            @slack_notifier.ping(*messager.message)
          rescue => e
            Rails.logger.error e
          end
        end

      end

      class SlackMessager

        include Errdo::Helpers::ViewsHelper # For the naming of the user in the message

        def initialize(parser, options = nil)
          @user = parser.user
          @backtrace = parser.short_backtrace
          @exception_name = parser.exception_name
          @exception_message = parser.exception_message
          @error = options ? options[:error] : nil
        end

        def message
          url_helpers = Errdo::Engine.routes.url_helpers
          error_url = url_helpers.error_url(@error) if @error
          [exception_string, attachments:
                                [
                                  title: @exception_message,
                                  title_link: error_url,
                                  fields: additional_fields,
                                  color: "#FF0E00"
                                ]]
        end

        private

        def exception_string
          @exception_name || 'None'
        end

        def additional_fields
          fields = [{ title: "Backtrace",
                      value: @backtrace.to_s }]
          if @user
            fields += [{ title: "User Affected",
                         value: user_show_string(@user) }]
          end
          return fields
        end

      end
    end
  end
end
