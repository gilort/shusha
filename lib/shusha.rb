require 'shusha/version'

module Shusha
  SHUSHA_PATH = File.join(File.dirname(__FILE__), 'shusha')

  def env
    @_env ||=  'development'
  end

  def version
    VERSION::STRING
  end

  #require "#{SHUSHA_PATH}/version.rb"
  #require 'require_all'
  #directory_load_order = %w(application)
  #directory_load_order.each do |dir|
  #  require_all "#{SHUSHA_PATH}/#{dir}/**/*.rb"
  #end
end