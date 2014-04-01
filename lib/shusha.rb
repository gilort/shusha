require 'shusha/version'

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
end