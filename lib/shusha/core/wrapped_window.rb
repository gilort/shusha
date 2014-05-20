module Shusha
  class WrappedWindow
    attr_accessor :window

    def initialize(klass)
      width, height = *config.resolution
      fullscreen = config.fullscreen
      @window = klass.new width, height, fullscreen
      @window.tap do |screen|
        screen.caption = config.caption
      end
    end

    def method_missing(name, *args, &blk)
      @window.send name, *args, &blk
    end

    def config
      @config ||= Shusha.context['shusha/configuration']
    end
  end
end