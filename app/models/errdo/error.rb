module Errdo
  class Error < ActiveRecord::Base

    self.table_name = Errdo.error_name

  end
end
