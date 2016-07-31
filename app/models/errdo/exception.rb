module Errdo
  class Exception

    def initialize(env)
      Errdo::Models::ErrorEnvParser.new(env) unless Errdo.error_name.nil?
    end

  end
end
