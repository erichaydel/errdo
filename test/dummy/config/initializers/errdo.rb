Errdo.setup do |config|
  config.current_user_method = :current_user

  config.user_string_method = :email

  config.user_show_path = :user_path

  config.authorize_with :cancan

  # This is the name of the class inside your application that the exceptions are stored as.
  # Exceptions are a reserved class name.
  #
  # If you want to rename it, make sure you also change the migration that comes with the gem.
  # Setting this to nil means that errors won't be tracked in the database
  # Note: The model name "{name}_instance" should also be free
  #
  config.error_name = :errors

  config.notify_with slack: { webhook: "https://hooks.slack.com/services/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" }
end
