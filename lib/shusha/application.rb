module Shusha
  DEVELOPMENT_ENV = 'development'

  class Application
    attr_accessor :scenes, :env

    def initialize(*args)
      @env = args[:env] || DEVELOPMENT_ENV
    end

    def config
      Configuration.instance
    end

    def start

    end

    def setup
      require_all
    end
  end
end