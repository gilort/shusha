# require 'require_all'
# require 'gosu'
# include Gosu
#
# require 'forwardable'
#
# # TODO move this to some logging class
# def log(output, level = :debug)
#   t = Time.now
#   puts "[#{t.min}:#{t.sec}:#{t.usec}] [#{level}] #{output}"
# end
#
# module Shusha
#   SHUSHA_PATH = File.join(File.dirname(__FILE__), 'shusha')
#
#   def env
#     @_env ||=  'development'
#   end
#
#   def version
#     VERSION::STRING
#   end
#
#   def self.configuration
#     Configuration.instance
#   end
#
#   def self.configure
#     yield configuration if block_given?
#   end
#
#   def self::update_autoload
#     directory_load_order = %w(core)
#     directory_load_order.each do |dir|
#       require_all "#{SHUSHA_PATH}/#{dir}/*.rb"
#     end
#     require_all "#{SHUSHA_PATH}/*.rb"
#   end
# end
#
# Shusha.update_autoload


require 'pathname'

require 'active_support'
require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/extract_options'

require 'shusha/application'
require 'shusha/version'

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
