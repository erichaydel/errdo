module Errdo
  class Notifier

    include Errdo::Helpers::NotificationHelper

    def initialize(*args)
      exception, string, params = separate_args(*args)
      @parser = Errdo::Models::ErrorLoggerParser.new(exception, string, params)
    end

    def notify
      Errdo.notify_with.each do |notifier|
        notifier.notify(@parser)
      end
    end

  end
end
