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

end
