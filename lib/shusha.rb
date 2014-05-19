require 'pathname'

require 'active_support'
require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/extract_options'

require 'shusha/application'
require 'shusha/version'
require 'gosu'

module Shusha
  extend ActiveSupport::Autoload

  class << self
    attr_accessor :application#, :cache, :logger

    delegate :initialize!, :initialized?, to: :application

    # The Configuration instance used to configure the Rails environment
    def configuration
      application.config
    end

    def root
      application && application.config.root
    end

    def env
      @_env ||= ActiveSupport::StringInquirer.new(ENV['SHUSHA_ENV'] || ENV['RACK_ENV'] || 'development')
    end

    def env=(environment)
      @_env = ActiveSupport::StringInquirer.new(environment)
    end

    def version
      VERSION::STRING
    end

    def public_path
      application && Pathname.new(application.paths['public'].first)
    end
  end
end
