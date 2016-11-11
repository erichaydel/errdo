require 'slack-notifier'
require_relative '../../helpers/views_helper.rb'

class NoOpHTTPClient
  def self.post uri, params={}
    binding.pry
  end
end

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
                                                  # http_client: NoOpHTTPClient
        end

        def notify(parser)
          messager = SlackMessager.new(parser)
          # begin
          p "ASDFASDFASDFASDFASDFASDF2"
          @slack_notifier.ping(*messager.message)
          # rescue => e
          # Rails.logger.error e
          # end
        end

      end

      class SlackMessager

        include Errdo::Helpers::ViewsHelper # For the naming of the user in the message
        include Errdo::Engine.routes.url_helpers

        def initialize(parser)
          @user = parser.user
          @backtrace = parser.short_backtrace
          @exception_name = parser.exception_name
          @exception_message = parser.exception_message
        end

        def message
          [exception_string, attachments:
                                [
                                  title: @exception_message,
                                  title_link: error_url(Errdo::ErrorOccurrence.last.error),
                                  fields: additional_fields,
                                  color: "#36a64f"
                                ]]
        end

        private

        def exception_string
          @exception_name || 'None'
        end

        def user_string
          @user.send(Errdo.user_show_method) if Errdo.user_show_method
        end

        def additional_fields
          fields = [{ title: "Backtrace",
                      value: @backtrace.to_s }]
          fields += { title: "User Affected", value: user_string } if @user
          return fields
        end

      end
    end
  end
end
