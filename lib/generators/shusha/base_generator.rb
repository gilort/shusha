require 'rake'
require 'thor'

module Shusha
  module Generators
    include Rake::DSL

    class BaseGenerator < Thor

      protected
      def print_version
        puts "Shusha #{Shusha::VERSION::STRING}"
      end

      def run_rake_task(*args)
        sh "rake #{args.shift}[#{args.join(',')}]"
      end

      def app_const_base
        @app_const_base ||= app_name.gsub(/\W/, '_').squeeze('_')
      end

      def app_name
        @app_name ||=  File.basename(destination_root).tr('.', '_')
      end

    end
  end
end