require 'singleton'
require 'fileutils'
require 'rails'
require 'conject'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/blank'

module Shusha
  class Application
    include ::Singleton

    attr_reader :context, :config, :window
    delegate :root, :paths, to: :config


    def initialize(&block)
      super()
      @context = Conject.default_object_context
      @config  = @context['shusha/configuration']
      @window  = @context['shusha/window']

      add_lib_to_load_path!
      instance_eval(&block) if block_given?
    end

    def add_lib_to_load_path! #:nodoc:
      path = File.join config.root, 'lib'
      if File.exist?(path) && !$LOAD_PATH.include?(path)
        $LOAD_PATH.unshift(path)
      end
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
