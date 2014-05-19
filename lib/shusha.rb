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

  autoload :Configuration, 'shusha/configuration'

  autoload :WindowsManager, 'shusha/core/windows_manager'

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

    def version
      VERSION::STRING
    end

    def public_path
      application && Pathname.new(application.paths['public'].first)
    end

    def start
      application.window.show
    end
  end
end
