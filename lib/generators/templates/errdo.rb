Errdo.setup do |config|
  # If you have the ability to track users through a log in process, this is
  # the method that determines who the current user is.  The default is current_user
  # config.current_user_method = :current_user

  # This determines how the user is displayed on the table of errors
  # Can be any method that a user responds to, I.E. Any method that returns a string
  # when called on user (Default is :email)
  config.user_string_method = :email
end
