module Shusha
  class Window < Gosu::Window
    def initialize

      super *Shusha.configuration.resolution, Shusha.configuration.fullscreen
      self.caption = Shusha.configuration.caption
    end
  end
end