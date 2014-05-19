module Shusha
  autoload :Window, 'shusha/core/window'

  class WindowsManager
    attr_reader :windows
    def initialize
      @windows ||= []
    end

    def add_window(window_class)
#      raise 'window_class should be instance of Shusha::Window' unless window_class.is_a? Shusha::Window
      @windows.push window_class
    end
  end
end