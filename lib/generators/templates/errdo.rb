Errdo.setup do |config|
  # If you have the ability to track who's logged in, setting the current_user_method
  # will allow the logged-in user to be recorded with the error
  # config.current_user_method = :current_user

  ## == Devise integration ==================
  # Some form of authentication here is basically necessary for authorization
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end

  ## == Authorization =======================
  # Setup authorization to be run as a before filter
  # This is run inside the controller instance so you can setup any authorization you need to.
  # By default, there is no authorization.
  #
  # config.authorize_with do
  #   redirect_to root_path unless warden.user.try(:is_admin?)
  # end
  #
  # To use an authorization adapter, pass the name of the adapter. For example,
  # to use with CanCanCan[https://github.com/CanCanCommunity/cancancan], pass it like this.
  # Currently, only cancan/cancancan is supported
  # config.authorize_with :cancan

  # This determines how the user is displayed on the table of errors
  # Can be any method that a user responds to, I.E. Any method that returns a string
  # when called on user (Default is :email)
  config.user_string_method = :email

  # Setting this will allow the user string to be linked to the show path
  # Default is the errdo root path
  # config.user_show_path = :user_path

  ## == Slack Integration ====================
  # See the github page at https://github.com/erichaydel/errdo for more info on how to set up slack
  # If you want to set up slack, this is the only required parameter
  # config.slack_webhook = 'YOUR-WEBHOOK-HERE'

  # You can customize what icon and name the notification posts with. Default is an explosion and "Errdo-bot"
  # config.slack_icon = 'boom'
  # config.slack_name = 'Errdo-bot'

  # This configures the channel to post error notifications to.  If nothing is set, it will post the the default
  # config.slack_channel = '#channel'
end
