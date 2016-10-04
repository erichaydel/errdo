class StaticController < ApplicationController

  def home
  end

  def generic_error
    raise "standard-error"
  end

  def long_error
    raise "e" * 256
  end

  def log
    Errdo.error "This is the error", user: current_user, data: "This is the data"
  end

end
