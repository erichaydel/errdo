require 'test_helper'


if defined?(ActiveJob::Base)
  class FailJob < ActiveJob::Base

    queue_as :default

    def perform(*_args)
      raise "AsynchronousFailure"
    end

  end
end

class NonWebTest < ActionDispatch::IntegrationTest

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

  if defined?(ActiveJob::Base)
    context "active jobs" do
      should "log to errdo when job fails asynchronously" do
        assert_difference 'Errdo::ErrorOccurrence.count', 1 do
          # rubocop:disable Style/RescueModifier
          FailJob.perform_now rescue ""
        end
      end
    end
  end

end
