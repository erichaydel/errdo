require 'test_helper'

FAILSAFE_FAIL_STRING = "If you are the administrator of this website, then please read this web application's \
                        log file and/or the web server's log file to find out what went wrong.".freeze

class PluginsIntegrationTest < ActionDispatch::IntegrationTest

  setup do
    Errdo.notify_with slack: { webhook: "https://slack.com/test" }
  end

  context "slack integration" do
    should "send a slack notification when error is hit" do
      stub_request :any, /.*slack.*/
      get static_generic_error_path
      assert_requested :any, /.*slack.*/
    end

    should "not send a slack notification when error is hit if webhook is not set" do
      Errdo.instance_variable_set(:@notifiers, [])
      stub_request :any, /.*slack.*/
      get static_generic_error_path
      assert_not_requested :any, /.*slack.*/
    end

    should "correctly send a notification when there is no database stored error" do
      Errdo.error_name = nil
      stub_request :any, /.*slack.*/
      get static_generic_error_path
      Errdo.error_name = :errors
      assert_requested :any, /.*slack.*/
    end

    should "not fail when the slack ping returns an error" do
      stub_request(:any, /.*slack.*/).to_raise(StandardError)
      get static_generic_error_path
      assert_not response.body.include? FAILSAFE_FAIL_STRING
    end
  end

  teardown do
    Errdo.error_name = :errors
    Errdo.instance_variable_set(:@notifiers, [])
  end

  private

  def _sign_in(user)
    post user_session_path, 'user[email]' => user.email, 'user[password]' => 'foobar'
  end

end
