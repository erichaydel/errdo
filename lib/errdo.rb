require 'errdo/engine'

module Errdo
  mattr_accessor :error_name
  @@error_name = :error

  def self.setup
    yield self
  end
end
