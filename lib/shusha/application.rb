module Shusha
  class Application
    def config #:nodoc:
      @config ||= Application::Configuration.new(find_root_with_flag('Gemfile', Dir.pwd))
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

    class << self
      attr_accessor :called_from
    end
  end
end