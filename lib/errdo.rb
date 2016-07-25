require 'errdo/engine'

module Errdo
  def self.setup
    yield self
  end
end
