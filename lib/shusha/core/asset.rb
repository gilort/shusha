module Shusha
  class Asset
    construct_with 'shusha/configuration', 'shusha/windows_manager'

    def initialize

    end

    def image(source, tileable, width, height)
      Gosu::Image.new(windows_manager.current_window.window, File.expand_path(source, configuration.root), tileable, 0, 0, width, height)
    end
  end
end