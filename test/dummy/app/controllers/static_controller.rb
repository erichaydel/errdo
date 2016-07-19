class StaticController < ApplicationController

  def home
  end

  def generic_error
    raise "standard-error"
  end

end
