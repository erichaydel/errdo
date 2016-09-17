require 'test_helper'

class PluginsIntegrationTest < ActionDispatch::IntegrationTest

  setup do
    Errdo.error_name = "errors"
  end

  context "slack integration" do
    should "send a slack notification when error is hit" do
      Errdo.stub :slack_webhook, "https://slack.com/test" do
        stub_request(:any, /.*slack.*/)
        get static_generic_error_path
        assert_requested :any, /.*slack.*/
      end
      Errdo.instance_variable_set(:@slack_notifier, nil)
    end
  end

  private

  def _sign_in(user)
    post user_session_path, 'user[email]' => user.email, 'user[password]' => 'foobar'
  end

end
