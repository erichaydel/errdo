module Errdo
  class Error

    def initialize(env)
      Errdo::Models::ErrorEnvParser.new(env) unless Errdo.error_name.nil?
    end

  end

  # This class backs Error in the database
  class DbError < ActiveRecord::Base

    self.table_name = Errdo.error_name

    def self.filter_env(env)
      # If no database for errors, don't bother parsing env (For now)
    end

  end
end
