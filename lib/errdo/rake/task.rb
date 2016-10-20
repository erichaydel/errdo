module Rake
  class Task

    alias execute_task execute

    # rubocop:disable Lint/RescueException
    def execute(args = nil)
      execute_task(args)
    rescue Interrupt => e
      raise e # Dont log if it's an interrupt
    rescue Exception => e
      Errdo.error(e, args) if Errdo.log_task_exceptions
      raise e
    end
    # rubocop:enable Lint/RescueException

  end
end
