module Shusha
  class Application
    class Configuration
      attr_accessor :logger, :log_formatter, :log_tags

      def initialize(root=nil)
        super()
        @root = root
      end
      
      def paths
        @paths ||= begin
          paths = Rails::Paths::Root.new(@root)

          paths.add 'app',                 eager_load: true, glob: '*'
          paths.add 'app/assets',          glob: '*'
          paths.add 'app/controllers',     eager_load: true
          paths.add 'app/helpers',         eager_load: true
          paths.add 'app/models',          eager_load: true
          paths.add 'app/mailers',         eager_load: true
          paths.add 'app/views'

          paths.add 'app/controllers/concerns', eager_load: true
          paths.add 'app/models/concerns',      eager_load: true

          paths.add 'lib',                 load_path: true
          paths.add 'lib/assets',          glob: '*'
          paths.add 'lib/tasks',           glob: '**/*.rake'

          paths.add 'config'
          paths.add 'config/environments', glob: "#{Shusha.env}.rb"
          paths.add 'config/initializers', glob: '**/*.rb'
          paths.add 'config/locales',      glob: '*.{rb,yml}'
          paths.add 'config/routes.rb'

          paths.add 'db'
          paths.add 'db/migrate'
          paths.add 'db/seeds.rb'

          paths.add 'vendor',              load_path: true
          paths.add 'vendor/assets',       glob: '*'

          paths
          paths.add 'config/database',    with: 'config/database.yml'
          paths.add 'config/environment', with: 'config/environment.rb'
          paths.add 'lib/templates'
          paths.add 'log',                with: "log/#{Shusha.env}.log"
          paths.add 'public'
          paths.add 'public/javascripts'
          paths.add 'public/stylesheets'
          paths.add 'tmp'
          paths
        end
      end

      def encoding=(value)
        @encoding = value
        silence_warnings do
          Encoding.default_external = value
          Encoding.default_internal = value
        end
      end

      # Loads and returns the configuration of the database.
      def database_configuration
        yaml = paths['config/database'].first
        if File.exists?(yaml)
          YAML.load yaml
        elsif ENV['DATABASE_URL']
          nil
        else
          raise "Could not load database configuration. No such file - #{yaml}"
        end
      rescue Psych::SyntaxError => e
        raise "YAML syntax error occurred while parsing #{paths['config/database'].first}. " \
              'Please note that YAML must be consistently indented using spaces. Tabs are not allowed. ' \
              "Error: #{e.message}"
      end
    end
  end
end
 