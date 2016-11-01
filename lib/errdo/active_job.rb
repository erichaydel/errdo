module Errdo
  module ActiveJob
    extend ActiveSupport::Concern

    included do
      rescue_from(Exception) do |e|
        Errdo.error(e)

        raise e
      end
    end
  end
end
