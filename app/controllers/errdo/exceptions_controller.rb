module Errdo
  class ExceptionsController < ActionDispatch::PublicExceptions

    # attr_accessor :public_path

    # def initialize(public_path)
    #   super
    # end

    def call(env)
      status       = env["PATH_INFO"][1..-1]
      request      = ActionDispatch::Request.new(env)
      content_type = request.formats.first
      body         = {  status: status,
                        error: Rack::Utils::HTTP_STATUS_CODES.fetch(status.to_i, Rack::Utils::HTTP_STATUS_CODES[500]) }

      Errdo::Exception.new(env)
      render(status, content_type, body)
    end

    # private

    # def render(status, content_type, body)
    #   super
    # end

    # def render_format(status, content_type, body)
    #   super
    # end

    # def render_html(status)
    #   super
    # end

  end
end
