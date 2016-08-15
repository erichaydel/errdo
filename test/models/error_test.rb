require 'test_helper'

class ErrorTest < ActiveSupport::TestCase

  context "model validations" do
    setup do
      @error = FactoryGirl.create(:error)
    end

    should "force backtrace_hash to be unique" do
      @second_error = FactoryGirl.create(:error)
      @second_error.backtrace = @error.backtrace
      assert_not @second_error.valid?
    end
  end

  context "model linkages" do
    setup do
      @error = FactoryGirl.create(:error)
    end

    should "have correct relations" do
      @error.error_occurrences
    end

    should "have counter cache for occurrences" do
      assert_difference '@error.occurrence_count', 1 do
        @error.error_occurrences.create
      end
    end
  end

  context "methods" do
    setup do
      @error = FactoryGirl.create(:error)
    end

    should "last_occurrence should get most recent occurrence" do
      @occ1 = @error.error_occurrences.create(created_at: 1.week.ago)
      @occ2 = @error.error_occurrences.create(created_at: 2.weeks.ago)
      assert_equal @occ1, @error.last_occurrence
    end
  end

end
