module Shusha
  module Generators

    class AppGenerator < BaseGenerator
      include Thor::Actions

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates/')
      end

      desc 'new PATH', 'Generates a new shusha game at PATH.'
      def new(*args)
        game_name = args[0]
        self.destination_root = game_name

        #if Shusha::VERSION::RC > 0
        #  @shusha_version = Shusha.version
        #else
        #  @shusha_version = '~> '+[Shusha::VERSION::MAJOR, Shusha::VERSION::MINOR, '0'].join('.')
        #end

        directory self.class.source_root, '.'
      end
      desc 'n PATH', 'Generates a new gamebox game at PATH.'
      alias_method :n, :new

      desc 'start', 'starts the application'
      def start
        print_version
        run_rake_task('run')
      end
      desc 's', 'starts the application'
      alias_method :s, :start

      desc 'debug', 'starts the application in debug'
      def debug
        print_version
        run_rake_task('debug')
      end
      desc 'd', 'starts the application in debug'
      alias_method :d, :debug

      desc 'generate [actor|behavior|stage] NAME', 'Shusha generator, this will generate templated files for you for quicker development'
      def generate(*args)
        run_rake_task("generate:#{args.shift}", *args)
      end
      desc 'g [actor|behavior|stage] NAME', 'Shusha generator, this will generate templated files for you for quicker development'
      alias_method :g, :generate
    end
  end
end