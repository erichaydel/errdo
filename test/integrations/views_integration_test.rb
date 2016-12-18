require 'test_helper'

class ViewsIntegrationTest < ActionDispatch::IntegrationTest

  include Errdo::Helpers::ViewsHelper

  context "views" do
    setup do
      get_via_redirect static_generic_error_path
      @errdo = Errdo::Engine.routes.url_helpers
    end

    should "be able to successfully get the index" do
      get @errdo.root_path
      assert_response :success
    end

    should "be able to successfully get the error's page" do
      get @errdo.error_path(Errdo::Error.last)
      assert_response :success
    end

    should "be able to get an error's page with a specific instance selected" do
      get @errdo.error_path(Errdo::Error.last, occurrence_id: Errdo::ErrorOccurrence.last)
      assert_response :success
    end

    should "strip off asset hash" do
      get static_view_error_path
      assert_nil Errdo::Error.last.backtrace[0] =~ /[_]{1,}[0-9]+/
    end
  end

end
