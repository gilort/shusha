module Shusha
  class Asset
    construct_with 'shusha/configuration', 'shusha/windows_manager'

    def initialize
      @image_path = configuration.paths['resources/images'].first
    end

    def image(source, tileable, width, height)
      Gosu::Image.new(clean_window, image_path(source), tileable, 0, 0, width, height)
    end

    private
    def clean_window
      windows_manager.current_window.window
    end

    def image_path(image)
      File.expand_path(resource, @image_path)
    end
  end
end