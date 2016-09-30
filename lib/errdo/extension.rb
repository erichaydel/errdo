module Errdo
  # rubocop:disable MutableConstant
  EXTENSIONS = []
  AUTHORIZATION_ADAPTERS = {}
  NOTIFICATION_ADAPTERS = {}
  # rubocop:enable MutableConstant

  # The extension may define various adapters (e.g., for authorization) and
  # register those via the options hash.
  def self.add_extension(extension_key, extension_definition, options = {})
    options.assert_valid_keys(:authorization)

    EXTENSIONS << extension_key

    if options[:authorization]
      AUTHORIZATION_ADAPTERS[extension_key] = extension_definition::AuthorizationAdapter
    end
  end

  def self.add_notification(notification_key, notification_definition, options = {})
    options.assert_valid_keys(:notification)

    EXTENSIONS << notification_key

    if options[:notification]
      NOTIFICATION_ADAPTERS[notification_key] = notification_definition::NotificationAdapter
    end
  end
end
