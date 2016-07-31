require 'test_helper'

class ErrorsIntegrationTest < ActionDispatch::IntegrationTest

  should "render a 404 error page" do
    get "#{root_path}/not-a-path"
    assert_equal 404, @response.status
  end

  should "render a 500 error page" do
    get static_generic_error_path
    assert_equal 500, @response.status
  end

  context "model creation after an error" do
    should "make an error in the database if table name is set" do

    end

    should "not make an error in the database if table name is not set" do

    end

    should "not store a password in the params" do

    end
  end


end
