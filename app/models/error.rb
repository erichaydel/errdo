module Errdo
  class Error < ActiveRecord::Base

    self.table_name = @@error_name

  end
end
