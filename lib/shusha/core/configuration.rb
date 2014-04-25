require 'singleton'

module Shusha
  class Configuration
    include ::Singleton

    attr_reader :root

    attr_writer :autoload_paths

    def initialize(root = nil)
      @root = find_root_with_flag('Gemfile', Dir.pwd)
      @options ||= {}
      autoload_paths[:models] #= File.expand_path
    end

    def paths
      @paths ||= begin
        paths = Rails::Paths::Root.new(@root)

        paths.add 'app',                 eager_load: true, glob: '*'
        paths.add 'resources',          glob: '*'
        paths.add 'app/models',          eager_load: true
        paths.add 'app/views'

        paths.add 'app/models/concerns',      eager_load: true

        paths.add 'lib',                 load_path: true
        paths.add 'lib/assets',          glob: '*'
        paths.add 'lib/tasks',           glob: '**/*.rake'

        paths.add 'config'
        paths.add 'config/environments', glob: '#{Shusha.env}.rb'
        paths.add 'config/initializers', glob: '**/*.rb'
        paths.add 'config/locales',      glob: '*.{rb,yml}'

        paths.add 'db'
        paths.add 'db/migrate'

        paths.add 'config/database',    with: 'config/database.yml'
        paths.add 'config/environment', with: 'config/environment.rb'
        paths.add 'lib/templates'
        paths.add 'log',                with: "log/#{Shusha.env}.log"
        paths.add 'tmp'
        paths
      end
    end

    def respond_to?(name)
      super || @options.key?(name.to_sym)
    end

    # Loads and returns the entire raw configuration of database from
    # values stored in `config/database.yml`.
    def database_configuration
      yaml = Pathname.new(paths['config/database'].first || '')
      raise "Could not load database configuration. No such file - #{yaml}" unless yaml.exist?

      YAML.load(yaml.read) || {}
    rescue Psych::SyntaxError => e
      raise "YAML syntax error occurred while parsing #{paths['config/database'].first}. " \
              'Please note that YAML must be consistently indented using spaces. Tabs are not allowed. ' \
              "Error: #{e.message}"
    rescue => e
      raise e, "Cannot load `Rails.application.database_configuration`:\n#{e.message}", e.backtrace
    end

    private
    def method_missing(name, *args, &blk)
      if name.to_s =~ /=$/
        @options[$`.to_sym] = args.first
      elsif @options.key?(name)
        @options[name]
      else
        super
      end
    end

  end
end