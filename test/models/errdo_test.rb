require 'test_helper'

class ErrdoTest < ActiveSupport::TestCase

  context "methods on the module" do
    context "warn and error" do
      setup do
        Errdo.notify_with slack: { webhook: "https://slack.com/test" }
        stub_request :any, /.*slack.*/
      end

      teardown do
        Errdo.instance_variable_set(:@notifiers, [])
      end

      should "create an error and send notification with Errdo.warn" do
        assert_difference 'Errdo::Error.count', 1 do
          begin
            raise "error stuff"
          rescue => e
            Errdo.error(e, "Cool beans")
          end
        end
        assert_requested :any, /.*slack.*/
      end

      should "create an error and send notification with Errdo.warn even when nothing is set" do
        assert_difference 'Errdo::Error.count', 1 do
          Errdo.error
        end
        assert_requested :any, /.*slack.*/
      end

      should "create an error with the correct params" do
        exception = nil
        begin
          raise "Error stuff"
        rescue => e
          Errdo.error(e, "Cool beans", user: User.first, data: "Here's some data")
          exception = e
        end
        error = Errdo::Error.last
        occ = Errdo::ErrorOccurrence.last

        assert_equal exception.class.name, error.exception_class_name
        assert_equal "Cool beans", error.exception_message
        assert_equal exception.backtrace, error.backtrace
        assert_equal occ.param_values, user: User.first, data: "Here's some data"
        assert_equal occ.experiencer, User.first
      end

      should "create an error with no exception and set params" do
        Errdo.error("Cool beans", user: User.first, data: "Here's some data")
        occ = Errdo::ErrorOccurrence.last

        assert_equal occ.param_values, user: User.first, data: "Here's some data"
      end
    end
  end

end
