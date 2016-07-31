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
      assert_difference 'Errdo::Error.count', 1 do
        get static_generic_error_path
      end
      assert_difference 'Errdo::ErrorOccurrence.count', 1 do
        get static_generic_error_path
      end
    end

    # Ideally, we would like to test this in a unit test, but basically by definition we need an error environment
    should "make an error and occurrence with the right fields" do
      get static_generic_error_path, {}, http_get_headers
      @error = Errdo::Error.last
      @error_occurrence = Errdo::ErrorOccurrence.last

      assert_not_nil @error.exception_class_name, "Exception class name"
      assert_not_nil @error.exception_message, "Exception message"
      assert_not_nil @error.http_method, "Http method"
      assert_not_nil @error.host_name, "Host name"
      assert_not_nil @error.url, "Url"
      assert_not_nil @error.backtrace, "Backtrace"

      assert_not_nil @error_occurrence.ip, "IP"
      assert_not_nil @error_occurrence.user_agent, "User Agent"
      assert_not_nil @error_occurrence.referer, "Referer"
      assert_not_nil @error_occurrence.query_string, "Query string"
      assert_not_nil @error_occurrence.cookie_values, "Cookie values"
      assert_not_nil @error_occurrence.header_values, "Header values"
    end

    should "not make an error in the database if table name is not set" do

    end

    should "not store a password in the params" do

    end
  end

  private

  def http_get_headers
    {
      "HTTP_USER_AGENT" => "TestGuy",
      "HTTP_REFERER" => "Referer",
    }
  end

end
