require 'test_helper'

class FailJob < ActiveJob::Base

  queue_as :default

  def perform(*_args)
    raise "AsynchronousFailure"
  end

end

class NonWebTest < ActionDispatch::IntegrationTest

  context "active jobs" do
    should "log to errdo when job fails asynchronously" do
      assert_difference 'Errdo::ErrorOccurrence.count', 1 do
        # rubocop:disable Style/RescueModifier
        FailJob.perform_now rescue ""
      end
    end
  end

end
