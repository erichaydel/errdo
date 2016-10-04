module Errdo
  module Helpers
    module NotificationHelper
      def separate_args(*args)
        exception = nil
        string = nil
        params = nil

        args.each do |arg|
          if arg.is_a?(StandardError)
            exception = arg
          elsif arg.is_a?(String)
            string = arg
          elsif arg.is_a?(Hash)
            params = arg
          end
        end
        return [exception, string, params]
      end
    end
  end
end
