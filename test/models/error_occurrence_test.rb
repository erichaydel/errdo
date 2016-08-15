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

  context "callbacks" do
    should "update last_occurrence of error when created" do
      @error = FactoryGirl.create(:error)
      @occurrence = FactoryGirl.create(:error_occurrence, error: @error)
      assert_equal @error.last_occurred_at, @occurrence.created_at
    end
  end

end
