require 'test_helper'

class ErrorsIntegrationTest < ActionDispatch::IntegrationTest

  setup do
    Errdo.error_name = "errors"
  end

  should "render a 404 error page" do
    get "/not-a-path"
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
    should "make an error and error_occurrence with the right fields" do
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
      assert_not_nil @error_occurrence.param_values, "Param values"
      assert_not_nil @error_occurrence.cookie_values, "Cookie values"
      assert_not_nil @error_occurrence.header_values, "Header values"
    end

    should "not make an error in the database if table name is not set" do
      # Theoretically, there shouldn't even be an error table
      Errdo.stub :error_name, nil do
        get static_generic_error_path
      end
    end

    should "not store a password in the params" do
      get static_generic_error_path, http_dirty_params

      @error_occurrence = Errdo::ErrorOccurrence.last
      dirty_words.each do |dirty_word|
        assert_equal "...", @error_occurrence.param_values[dirty_word], "Dirty word #{dirty_word} not censored"
      end
    end

    should "not store a configurable dirty param in the params" do
      Errdo.dirty_words += ["dirtyyyyy"]
      get static_generic_error_path, "dirtyyyyy" => "stuff"
      @error_occurrence = Errdo::ErrorOccurrence.last
      assert_equal "...", @error_occurrence.param_values["dirtyyyyy"]
    end

    should "only store an error occurrence if same error already exists" do
      get static_generic_error_path
      assert_difference 'Errdo::Error.count', 0 do
        get static_generic_error_path
      end
      assert_difference 'Errdo::ErrorOccurrence.count', 1 do
        get static_generic_error_path
      end
    end

    should "not have overly long error hash" do
      get static_long_error_path
      assert Errdo::Error.last.backtrace_hash.length <= 255
    end

    should "make an error with the current user if a user is logged in" do
      _sign_in users(:user)
      get static_generic_error_path
      assert_equal users(:user), Errdo::ErrorOccurrence.last.experiencer
    end

    should "make an error if log404 is set and 404 is hit" do
      Errdo.log404 = true
      assert_difference 'Errdo::ErrorOccurrence.count', 1 do
        get "/not-a-path"
      end
    end

    should "not make an error if log404 is not set and 404 is hit" do
      Errdo.log404 = false
      assert_difference 'Errdo::ErrorOccurrence.count', 0 do
        get "/not-a-path"
      end
    end
  end

  private

  def dirty_words
    %w(password passwd password_confirmation secret confirm_password secret_token)
  end

  def http_dirty_params
    {
      "password" => "dirty",
      "passwd" => "dirty",
      "password_confirmation" => "dirty",
      "secret" => "dirty",
      "confirm_password" => "dirty",
      "secret_token" => "dirty"
    }
  end

  def http_get_headers
    {
      "HTTP_USER_AGENT" => "TestGuy",
      "HTTP_REFERER" => "Referer"
    }
  end

  def _sign_in(user)
    post user_session_path, 'user[email]' => user.email, 'user[password]' => 'foobar'
  end

end
