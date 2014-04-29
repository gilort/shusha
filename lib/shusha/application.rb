require 'singleton'
require 'fileutils'
require 'rails'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/blank'

module Shusha
  class Application
    include ::Singleton
    autoload :Configuration, 'shusha/core/configuration'

    class << self
      delegate :config, to: :instance
      attr_accessor :called_from
      def inherited(base)
        super
        base.called_from = begin
          call_stack = caller.map { |p| p.sub(/:\d+.*/, '') }
          File.dirname(call_stack.detect { |p| p !~ %r[railties[\w.-]*/lib/rails|rack[\w.-]*/lib/rack] })#FIXME fix regex
        end

        Shusha.application ||= base.instance
      end
    end
    delegate :root, :paths, to: :config

    INITIAL_VARIABLES = [:config, :app_env_config] # :nodoc:

    def initialize(initial_variables= {}, &block)
      super()
      @initialized       = false
      @app_env_config    = nil

      add_lib_to_load_path!

      initial_variables.each do |variable_name, value|
        instance_variable_set("@#{variable_name}", value) if INITIAL_VARIABLES.include?(variable_name)
      end

      instance_eval(&block) if block_given?
      @initialized = true
    end

    # Returns true if the application is initialized.
    def initialized?
      @initialized
    end

    def add_lib_to_load_path! #:nodoc:
      path = File.join config.root, 'lib'
      if File.exist?(path) && !$LOAD_PATH.include?(path)
        $LOAD_PATH.unshift(path)
      end
    end

    def require_environment! #:nodoc:
      environment = paths['config/environment'].existent.first
      require environment if environment
    end

    def config #:nodoc:
      @config ||= Application::Configuration.new find_root_with_flag('Gemfile', Dir.pwd)
    end

    def config=(configuration) #:nodoc:
      @config = configuration
    end


    def to_app #:nodoc:
      self
    end

    def find_root_with_flag(flag, default=nil) #:nodoc:
      root_path = self.class.called_from

      while root_path && File.directory?(root_path) && !File.exist?("#{root_path}/#{flag}")
        parent = File.dirname(root_path)
        root_path = parent != root_path && parent
      end

      root = File.exist?("#{root_path}/#{flag}") ? root_path : default
      raise "Could not find root path for #{self}" unless root

      Pathname.new File.realpath root
    end
  end
end
