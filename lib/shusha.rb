require 'require_all'
require 'gosu'
include Gosu

require 'forwardable'

# TODO move this to some logging class
def log(output, level = :debug)
  t = Time.now
  puts "[#{t.min}:#{t.sec}:#{t.usec}] [#{level}] #{output}"
end

module Shusha
  SHUSHA_PATH = File.join(File.dirname(__FILE__), 'shusha')

  def env
    @_env ||=  'development'
  end

  def version
    VERSION::STRING
  end

  def self.configuration
    Configuration.instance
  end

  def self.configure
    yield configuration if block_given?
  end

  def self::update_autoload
    directory_load_order = %w(core)
    directory_load_order.each do |dir|
      require_all "#{SHUSHA_PATH}/#{dir}/*.rb"
    end
    require_all "#{SHUSHA_PATH}/*.rb"
  end
end

Shusha.update_autoload