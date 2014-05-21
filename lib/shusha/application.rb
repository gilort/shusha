require 'singleton'
require 'fileutils'
require 'rails'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/blank'
require 'active_support/dependencies'

module Shusha
  class Application
    include ::Singleton

    attr_reader :config, :windows_manager
    delegate :root, :paths, to: :config


    def initialize(&block)
      super()
      @config  = Shusha.context['shusha/configuration']
      @windows_manager  = Shusha.context['shusha/windows_manager']

      add_lib_to_load_path!
      instance_eval(&block) if block_given?
      ActiveSupport::Dependencies.autoload_paths.unshift(*(config.paths.autoload_paths + config.paths.eager_load + config.paths.autoload_once).uniq)
      ActiveRecord::Base.establish_connection @config.database_configuration[:development]
    end

    def add_lib_to_load_path! #:nodoc:
      path = config.root.join('lib').to_s
      $LOAD_PATH.unshift(path) if File.exists?(path)
    end

    class << self
      delegate :config, to: :instance

      def inherited(base)
        super
        Shusha.application ||= base.instance
      end
    end
  end
end
