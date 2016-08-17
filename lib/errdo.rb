require 'errdo/engine'

module Errdo
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

  def self.setup
    yield self
  end
end
