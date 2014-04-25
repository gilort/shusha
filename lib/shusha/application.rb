# module Shusha
#   DEVELOPMENT_ENV = 'development'
#
#   class Application
#     attr_accessor :scenes, :env
#
#     def initialize(args={})
#       @env = args[:env] || DEVELOPMENT_ENV
#     end
#
#     #FIXME remove double method
#     def config
#       Configuration.instance
#     end
#
#
#     def self::config
#       Configuration.instance
#     end
#
#     def start
#
#     end
#
#     def setup
#       require_all
#     end
#   end
#
#   class << self
#     def config
#       Configuration.instance
#     end
#   end
# end
#





require 'singleton'
require 'fileutils'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/blank'

module Shusha
  # In Rails 3.0, a Rails::Application object was introduced which is nothing more than
  # an Engine but with the responsibility of coordinating the whole boot process.
  #
  # == Initialization
  #
  # Rails::Application is responsible for executing all railties and engines
  # initializers. It also executes some bootstrap initializers (check
  # Rails::Application::Bootstrap) and finishing initializers, after all the others
  # are executed (check Rails::Application::Finisher).
  #
  # == Configuration
  #
  # Besides providing the same configuration as Rails::Engine and Rails::Railtie,
  # the application object has several specific configurations, for example
  # "cache_classes", "consider_all_requests_local", "filter_parameters",
  # "logger" and so forth.
  #
  # Check Rails::Application::Configuration to see them all.
  #
  # == Routes
  #
  # The application object is also responsible for holding the routes and reloading routes
  # whenever the files change in development.
  #
  # == Middlewares
  #
  # The Application is also responsible for building the middleware stack.
  #
  # == Booting process
  #
  # The application is also responsible for setting up and executing the booting
  # process. From the moment you require "config/application.rb" in your app,
  # the booting process goes like this:
  #
  #   1)  require "config/boot.rb" to setup load paths
  #   2)  require railties and engines
  #   3)  Define Rails.application as "class MyApp::Application < Rails::Application"
  #   4)  Run config.before_configuration callbacks
  #   5)  Load config/environments/ENV.rb
  #   6)  Run config.before_initialize callbacks
  #   7)  Run Railtie#initializer defined by railties, engines and application.
  #       One by one, each engine sets up its load paths, routes and runs its config/initializers/* files.
  #   8)  Custom Railtie#initializers added by railties, engines and applications are executed
  #   9)  Build the middleware stack and run to_prepare callbacks
  #   10) Run config.before_eager_load and eager_load! if eager_load is true
  #   11) Run config.after_initialize callbacks
  #
  # == Multiple Applications
  #
  # If you decide to define multiple applications, then the first application
  # that is initialized will be set to +Rails.application+, unless you override
  # it with a different application.
  #
  # To create a new application, you can instantiate a new instance of a class
  # that has already been created:
  #
  #   class Application < Rails::Application
  #   end
  #
  #   first_application  = Application.new
  #   second_application = Application.new(config: first_application.config)
  #
  # In the above example, the configuration from the first application was used
  # to initialize the second application. You can also use the +initialize_copy+
  # on one of the applications to create a copy of the application which shares
  # the configuration.
  #
  # If you decide to define rake tasks, runners, or initializers in an
  # application other than +Rails.application+, then you must run those
  # these manually.
  class Application
    include ::Singleton


    autoload :Configuration, 'rails/engine/configuration'
    # autoload :Bootstrap,              'rails/application/bootstrap'
    # autoload :Configuration,          'rails/application/configuration'
    # autoload :DefaultMiddlewareStack, 'rails/application/default_middleware_stack'
    # autoload :Finisher,               'rails/application/finisher'
    # autoload :Railties,               'rails/engine/railties'
    # autoload :RoutesReloader,         'rails/application/routes_reloader'

    class << self
      attr_accessor :called_from
      def inherited(base)
        base.called_from = begin
          call_stack = caller.map { |p| p.sub(/:\d+.*/, '') }
          File.dirname(call_stack.detect { |p| p !~ %r[railties[\w.-]*/lib/rails|rack[\w.-]*/lib/rack] })#FIXME fix regex
        end

        Shusha.application ||= base.instance
      end
    end

    attr_accessor :assets, :sandbox
    alias_method :sandbox?, :sandbox

    delegate :root, :paths, to: :config

    INITIAL_VARIABLES = [:config, :app_env_config, :secrets] # :nodoc:

    def initialize(initial_variables= {}, &block)
      super()
      @initialized       = false
      @app_env_config    = nil

      add_lib_to_load_path!

      initial_variables.each do |variable_name, value|
        instance_variable_set("@#{variable_name}", value) if INITIAL_VARIABLES.include?(variable_name)
      end

      instance_eval(&block) if block_given?
    end

    # Returns true if the application is initialized.
    def initialized?
      @initialized
    end

    # If you try to define a set of rake tasks on the instance, these will get
    # passed up to the rake tasks defined on the application's class.
    def rake_tasks(&block)
      self.class.rake_tasks(&block)
    end

    # Sends the initializers to the +initializer+ method defined in the
    # Rails::Initializable module. Each Rails::Application class has its own
    # set of initializers, as defined by the Initializable module.
    def initializer(name, opts={}, &block)
      self.class.initializer(name, opts, &block)
    end

    # Sends any runner called in the instance of a new application up
    # to the +runner+ method defined in Rails::Railtie.
    def runner(&blk)
      self.class.runner(&blk)
    end

    # Sends the +isolate_namespace+ method up to the class method.
    def isolate_namespace(mod)
      self.class.isolate_namespace(mod)
    end

    ## Rails internal API

    # This method is called just after an application inherits from Rails::Application,
    # allowing the developer to load classes in lib and use them during application
    # configuration.
    #
    #   class MyApplication < Rails::Application
    #     require "my_backend" # in lib/my_backend
    #     config.i18n.backend = MyBackend
    #   end
    #
    # Notice this method takes into consideration the default root path. So if you
    # are changing config.root inside your application definition or having a custom
    # Rails application, you will need to add lib to $LOAD_PATH on your own in case
    # you need to load files in lib/ during the application configuration as well.
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

    # Initialize the application passing the given group. By default, the
    # group is :default
    def initialize!(group=:default) #:nodoc:
      raise 'Application has been already initialized.' if @initialized
      @initialized = true
      self
    end

    def config #:nodoc:
      @config ||= Application::Configuration.instance
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
