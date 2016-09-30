require 'errdo/notifications/slack/notification_adapter'

Errdo.add_notification(:slack, Errdo::Notifications::Slack, notification: true)
