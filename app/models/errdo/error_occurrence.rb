module Errdo
  class ErrorOccurrence < ActiveRecord::Base

    self.table_name = "#{Errdo.error_name.to_s.singularize}_occurrences"

    serialize :param_values
    serialize :cookie_values
    serialize :header_values

    has_one :error

  end
end
