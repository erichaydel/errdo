require 'errdo/engine'
require 'errdo/extension'
require 'errdo/extensions/cancancan'
require 'errdo/notifications/slack'

require 'errdo/rake/task' if defined?(Rake::Task)

ActiveSupport.on_load(:active_job) do
  # Reports exceptions occurring in ActiveJob jobs.
  require 'errdo/active_job'
  include Errdo::ActiveJob
end

module Errdo
  # A lot of this authorization/authentication code was heavily inspired by Rails Admin gem, which is a great gem
  # https://github.com/sferik/rails_admin
  DEFAULT_AUTHENTICATE = proc {}
  DEFAULT_AUTHORIZE = proc {}

  # rubocop:disable Style/ClassVars
  mattr_accessor :error_name
  @@error_name = :error

  # This is the method that determines who the logged in user is
  # defaults to current_user because that's the devise default
  mattr_accessor :current_user_method
  @@current_user_method = nil

  # This determines how the user is displayed on the table of errors
  # Can be any method that a user responds to
  mattr_accessor :user_string_method
  @@user_string_method = :email

  # This is the 'show' page for a user so that you can click on a user and see all their info
  mattr_accessor :user_show_path
  @@user_show_path = nil

  mattr_accessor :dirty_words
  @@dirty_words = %w(password passwd password_confirmation secret confirm_password secret_token)

  # This determines whether a task that fails will log an exception
  mattr_accessor :log_task_exceptions
  @@log_task_exceptions = true

  mattr_accessor :log404
  @@log404 = false
  # rubocop:enable Style/ClassVars

  # == Authentication ==
  # Setup authentication to be run as a before filter
  # This is run inside the controller instance so you can setup any authentication you need to
  #
  # If you use devise, this will authenticate the same as _authenticate_user!_
  #
  # @example
  #   config.authenticate_with do
  #     authenticate_admin!
  #   end
  #
  def self.authenticate_with(&block)
    @authenticate = block ? block : nil
    @authenticate || DEFAULT_AUTHENTICATE
  end

  # == Authorization ==
  # Setup authorization to be run as a before filter
  # This is run inside the controller instance so you can setup any authorization you need to.
  #
  # By default, there is no authorization.
  #
  # @example
  #   config.authorize_with do
  #     redirect_to root_path unless warden.user.is_admin?
  #   end
  #
  # To use an authorization adapter, pass the name of the adapter. For example,
  # to use with CanCanCan[https://github.com/CanCanCommunity/cancancan], pass it like this.
  #
  # @example
  #   config.authorize_with :cancan
  def self.authorize_with(*args, &block)
    extension = args.shift
    if extension
      klass = Errdo::AUTHORIZATION_ADAPTERS[extension]
      @authorize = proc do
        @authorization_adapter = klass.new(*([self] + args).compact)
      end
    elsif block
      @authorize = block
    end
    @authorize || DEFAULT_AUTHORIZE
  end

  # == Notifications ==
  # Setup notifications
  #
  # Every configured notifier can be set here as
  # @example
  #   Errdo.notify_with slack: {  webhook: "WEBHOOK-URL",
  #                               channel: "#general"
  #                               icon: ":boom:",
  #                               name: "Errdo-bot" }
  #
  #
  # Right now, only slack is supported
  def self.notify_with(notifiers = nil)
    if notifiers
      @notifiers = []
      notifiers.each do |notifier|
        klass = Errdo::NOTIFICATION_ADAPTERS[notifier[0]]
        @notifiers.append(klass.new(**notifier[1])) # The options will be in the second field
      end
    end
    @notifiers ||= []
  end

  # Logs the error to the database (only)
  def self.log(*args)
    Errdo::Logger.new('info', *args).log
  end

  # Notifies without writing to the database
  def self.notify(*args)
    Errdo::Notifier.new(*args).notify
  end

  # Logs the error to the database as a warning
  def self.warn(*args)
    error = Errdo::Logger.new('warning', *args).log
    Errdo::Notifier.new(*args, error: error).notify
  end

  # Logs the error to the database and notifies the user
  def self.error(*args)
    error = Errdo::Logger.new('error', *args).log
    Errdo::Notifier.new(*args, error: error).notify
  end

  def self.setup
    yield self
  end
end
