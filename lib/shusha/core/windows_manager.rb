module Shusha
  autoload :Window, 'shusha/core/window'
  autoload :WrappedWindow, 'shusha/core/wrapped_window'

  class WindowsManager
    attr_reader :current_window

    def initialize
      @current_window = nil
      @cached_windows = {}
    end

    def default_window
      WrappedWindow.new Shusha::Window
    end

    def window(name)
      @current_window = @cached_windows.include?(name)? @cached_windows[name] :  create_window(name)
    end

    def create_window(window_name)
        @cached_windows[window_name] = WrappedWindow.new window_name.to_s.classify.constantize
    end

  end
end