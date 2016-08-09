require 'test_helper'

class ErrorOccurrenceTest < ActiveSupport::TestCase

  context "model linkages" do
    should "have correct relations" do
      assert Errdo::ErrorOccurrence.method_defined? :error
    end
  end

end
