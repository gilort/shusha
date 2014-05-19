module Shusha
  class Window < Gosu::Window
    construct_with 'shusha/configuration'

    def initialize

      super *configuration.resolution, configuration.fullscreen
      self.caption = configuration.caption
    end
  end
end