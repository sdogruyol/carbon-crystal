module CarbonController
  module Callbacks
    macro included
      include CarbonSupport::Callbacks(CarbonController::Base)
      define_callbacks(:process_action, CallbackChain::Options(CarbonController::Base).new(
                                          terminator: ->(controller : CarbonController::Base, result : Bool) { controller.response.body.present? },
                                          skip_after_callbacks_if_terminated: true)
      )

      def process_action(name, block)
        run_callbacks(:process_action) do
          previous_def
        end
      end
    end

    macro before_action(name)
      set_callback :process_action, :before, {{name}}
    end

    macro after_action(name)
      set_callback :process_action, :after, {{name}}
    end

    macro around_action(name)
      set_callback :process_action, :around, {{name}}
    end
  end
end
