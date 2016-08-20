require 'errdo/engine'
require 'errdo/extension'
require 'errdo/extensions/cancancan'

module Errdo
  # A lot of this authorization/authentication code was heavily inspired by Rails Admin gem, which is a great gem
  # https://github.com/sferik/rails_admin
  DEFAULT_AUTHENTICATE = proc {}
  DEFAULT_AUTHORIZE = proc {}

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

  def self.setup
    yield self
  end
end
