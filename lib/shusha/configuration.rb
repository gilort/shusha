module Shusha
  class Configuration
    attr_reader :root
    attr_writer :autoload_paths

    attr_accessor :resolution, :fullscreen, :caption, :needs_cursor

    def initialize
      @options ||= {}
      @root = get_root

      @fullscreen = false
      @resolution = [600, 800]
      @caption = 'Game Title'
      @needs_cursor = true
    end

    def paths
      @paths ||= begin
        paths = Rails::Paths::Root.new(@root)

        paths.add 'app', eager_load: true, glob: '*'
        paths.add 'resources', glob: '*'
        paths.add 'app/models/concerns', eager_load: true

        paths.add 'lib', load_path: true
        paths.add 'config'
        paths.add 'db'
        paths.add 'db/migrate'

        paths.add 'config/database', with: 'config/database.yml'
        paths.add 'config/environment', with: 'config/environment.rb'
        paths.add 'log', with: 'log/debug.log'
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

      config = YAML.load(yaml.read).symbolize_keys || {}

      config.each do |env, values|
        values = values.symbolize_keys
        values[:database] = File.expand_path values[:database], @root if values.include? :database
        config[env] = values
      end
    rescue Psych::SyntaxError => e
      raise "YAML syntax error occurred while parsing #{paths['config/database'].first}. " \
              'Please note that YAML must be consistently indented using spaces. Tabs are not allowed. ' \
              "Error: #{e.message}"
    rescue => e
      raise e, "Cannot load `Shusha.application.database_configuration`:\n#{e.message}", e.backtrace
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

    def get_root
      Bundler::SharedHelpers.in_bundle? ? Pathname.new(File.dirname(Bundler::SharedHelpers.default_gemfile)).realpath : nil
    end
  end
end