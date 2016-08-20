Errdo.setup do |config|
  # If you have the ability to track who's logged in, setting the current_user_method
  # will allow the logged in user to be recorded with the error
  # config.current_user_method = :current_user

  ## == Devise integration
  # Some form of authentication here is basically necessary for authorization
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end

  # This determines how the user is displayed on the table of errors
  # Can be any method that a user responds to, I.E. Any method that returns a string
  # when called on user (Default is :email)
  config.user_string_method = :email

  # Setting this will allow the user string to be linked to the show path
  # config.user_show_path = :user_path
end
