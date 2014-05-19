module Shusha
  class Window < Gosu::Window
    construct_with 'shusha/configuration'

    def initialize

      super *configuration.resolution, configuration.fullscreen
      self.caption = configuration.caption
    end

    class << self
      def inherited(base)
        super
        windows_manager.add_window base
      end

      private
      def windows_manager
        Shusha.application.context['shusha/windows_manager']
      end
    end
  end
end