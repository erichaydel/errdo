require 'test_helper'

class ErrorsIntegrationTest < ActionDispatch::IntegrationTest

  should "render a 404 error page" do
    get "#{root_path}/not-a-path"
    assert_equal @response.status, 404
  end

  should "render a 500 error page" do
    get static_generic_error_path
    assert_equal @response.status, 500
  end

end
