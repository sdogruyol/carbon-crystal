require "./metal"

module CarbonController
  class Base < Metal
    delegate :params, :request

    macro inherited
      def process_action(name, block)
        super
      end

      include CarbonController::Head
      include CarbonController::Session
      include CarbonController::Cookies
      include CarbonController::Flash
      include CarbonController::Callbacks
      include CarbonController::Instrumentation
    end

    def request
      @_request
    end

    def response
      @_response
    end

    macro render_template(template)
      response.body = CarbonViews::{{ @type.id.gsub(/Controller\+?/, "") }}::{{template.camelcase.id}}.new(controller = self).to_s
      response.headers["Content-Type"] = "text/html"
    end

    def render_text(text)
      response.body = text
      response.headers["Content-Type"] = "text/plain"
    end

    def render_json(object)
      response.body = object.to_json
      response.headers["Content-Type"] = "application/json"
    end
  end
end
