require 'test_helper'
require 'rake'

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

      should "create an error and send notification with Errdo.warning" do
        assert_difference 'Errdo::Error.count', 1 do
          Errdo.warn
        end
        assert_requested :any, /.*slack.*/
      end

      should "not create an error, but should send notification with Errdo.log" do
        assert_difference 'Errdo::Error.count', 0 do
          Errdo.notify
        end
        assert_requested :any, /.*slack.*/
      end

      should "create an error, but should not send notification with Errdo.info" do
        assert_difference 'Errdo::Error.count', 1 do
          Errdo.log
        end
        assert_not_requested :any, /.*slack.*/
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

      should "create an error and scrub the params" do
        Errdo.log("Cool beans2", password: "password")
        occ = Errdo::ErrorOccurrence.last
        assert_equal "...", occ.param_values[:password]
      end

      # rubocop:disable Style/RescueModifier
      # rubocop:disable Lint/HandleExceptions
      context "rake tasks" do
        setup do
          load "#{Rails.root}/lib/tasks/test.rake"
        end

        teardown do
          Rake.application['test:error'].reenable
          Rake.application['test:interrupt'].reenable
        end

        should "create an error when a task fails" do
          Errdo.log_task_exceptions = true
          assert_difference 'Errdo::ErrorOccurrence.count', 1 do
            Rake.application['test:error'].invoke rescue ""
          end
        end

        should "not create an error when a task fails with an interrupt" do
          Errdo.log_task_exceptions = true
          load "#{Rails.root}/lib/tasks/test.rake"
          assert_difference 'Errdo::ErrorOccurrence.count', 0 do
            begin
              Rake.application['test:interrupt'].invoke
            rescue Interrupt
            end
          end
        end

        should "create not an error when a task fails when not set" do
          Errdo.log_task_exceptions = false
          assert_difference 'Errdo::ErrorOccurrence.count', 0 do
            Rake.application['test:error'].invoke rescue ""
          end
        end
      end
      # rubocop:enable Style/RescueModifier
      # rubocop:enable Lint/HandleExceptions
    end
  end

end
