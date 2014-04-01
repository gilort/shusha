module Shusha
  class Configuration
    include Singleton

    attr_accessor :config_path, :data_path, :time_zone

    attr_writer :autoload_paths

    def initialize
      autoload_paths[:models] #= File.expand_path
    end

    def [](key)
      send key if respond_to? key
    end

    def []=(key, value)
      settings[key]=value  if respond_to? key
    end

    def autoload_paths
      @autoload_paths ||= {}
    end
  end
end