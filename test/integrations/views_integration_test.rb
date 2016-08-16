require 'test_helper'

class ViewsIntegrationTest < ActionDispatch::IntegrationTest

  setup do
    Errdo.error_name = "errors"
  end

  context "views" do
    setup do
      get_via_redirect static_generic_error_path
    end

    should "be able to successfully get the index" do
      get errdo_path
      assert_response :success
    end

    should "be able to successfully get the error's page" do
      get errdo.error_path(Errdo::Error.last)
      get errdo.error_path(Errdo::Error.last)
      assert_response :success
    end
  end

end
