require 'test_helper'

class ErrorOccurrenceTest < ActiveSupport::TestCase

  context "model linkages" do
    setup do
      @occ = FactoryGirl.create(:error_occurrence)
    end

    should "have correct relations" do
      @occ.error
    end
  end

end
