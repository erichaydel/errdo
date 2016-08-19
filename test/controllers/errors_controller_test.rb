require 'test_helper'

module Errdo
  class ErrorsControllerTest < ActionController::TestCase

    setup do
      @routes = Engine.routes
    end

    context "actions" do
      setup do
        @error = FactoryGirl.create(:error)
        @occ = FactoryGirl.create(:error_occurrence, error: @error)
      end

      context "update" do
        should "change the status" do
          put :update, id: @error.id, error: { status: "wontfix" }
          assert @error.reload.wontfix?
        end
      end
    end

  end
end
