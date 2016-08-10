class StaticController < ApplicationController

  def home
  end

  def generic_error
    raise "standard-error"
  end

  def long_error
    raise "e" * 256
  end

end
