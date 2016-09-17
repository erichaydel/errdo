require 'test_helper'

class PluginsIntegrationTest < ActionDispatch::IntegrationTest

  setup do
    Errdo.error_name = "errors"
    Errdo.slack_webhook = "https://slack.com/test"
  end

  context "slack integration" do
    should "send a slack notification when error is hit" do
      stub_request :any, /.*slack.*/
      get static_generic_error_path
      assert_requested :any, /.*slack.*/
    end

    should "not send a slack notification when error is hit if webhook is nil" do
      Errdo.slack_webhook = nil
      stub_request :any, /.*slack.*/
      get static_generic_error_path
      assert_not_requested :any, /.*slack.*/
    end

    should "correctly send a notification when there is no database stored error" do
      Errdo.error_name = nil
      stub_request :any, /.*slack.*/
      get static_generic_error_path
      assert_requested :any, /.*slack.*/
    end
  end

  teardown do
    Errdo.instance_variable_set(:@slack_notifier, nil)
    Errdo.slack_webhook = nil
  end

  private

  def _sign_in(user)
    post user_session_path, 'user[email]' => user.email, 'user[password]' => 'foobar'
  end

end
