require 'deep_merge'

module Noteman
  class BaseMan
    attr_accessor :config

    CONFIG_NAME = ".notemanrc"
    def initialize
      @config = read_config
      @config['path'] ||= "~/io"
      @config['viewer'] ||= "Marked 2"
      @config['inbox'] ||= "capture.md"
      @config['default_extention'] = "md"
      File.open(home_config, 'w') { |yf| YAML::dump(config, yf) }
    end

    def search_by_tags(*tags)
      results = []
      Dir.chdir(File.expand_path(@config['path']))
      Dir.glob("*.#{@config['default_extention']}").each do |file|
        metadata = MetaParser.get_metadata File.read(file)
        if metadata and metadata['tags']
          if (tags - metadata['tags']).empty?
            results << file
          end
        end
      end
      results
    end

    def fork_editor(input="")
      tmpfile = Tempfile.new('note')

      File.open(tmpfile.path,'w+') do |f|
        f.puts input
      end

      pid = Process.fork { system("$EDITOR #{tmpfile.path}") }

      trap("INT") {
        Process.kill(9, pid) rescue Errno::ESRCH
        tmpfile.unlink
        tmpfile.close!
        exit 0
      }

      Process.wait(pid)

      begin
        if $?.exitstatus == 0
          input = IO.read(tmpfile.path)
        else
          raise "Cancelled"
        end
      ensure
        tmpfile.close
        tmpfile.unlink
      end

      input
    end

    def home_config
      if Dir.respond_to?('home')
        File.join(Dir.home, CONFIG_NAME)
      else
        File.join(File.expand_path("~"), CONFIG_NAME)
      end
    end

    def read_config
      config = {}
      dir = Dir.pwd
      while(dir != '/')
        if File.exists? File.join(dir, CONFIG_NAME)
          config = YAML.load_file(File.join(dir, CONFIG_NAME)).deep_merge!(config)
        end
        dir = File.dirname(dir)
      end
      if config.empty? && File.exists?(home_config)
        config = YAML.load_file(home_config)
      end
      config
    end
  end
end
