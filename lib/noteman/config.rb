require 'deep_merge'

module Noteman
  module Config

    CONFIG_NAME = ".notemanrc"

    attr_reader :config

    def config
      if not defined? @config
        @config = read_from_file
        @config['notes_in'] ||= "~/io"
        @config['view_with'] ||= "Marked 2"
        @config['capture_to'] ||= "capture.md"
        @config['ends_with'] ||= "md"
				@config['fomula'] ||= {}
				@config['fomula']['cheatsheets'] ||= {
					'tags' => 'cheatsheet'
				}
				@config['fomula']['drafts'] ||= {
					'tags' => 'draft post',
					'tags_bool' => 'AND'
				}

        File.open(home_config, 'w') { |yf| YAML::dump(config, yf) }
      end
      @config
    end

    def home_config
      if Dir.respond_to?('home')
        File.join(Dir.home, CONFIG_NAME)
      else
        File.join(File.expand_path("~"), CONFIG_NAME)
      end
    end

    def read_from_file
      c = {}
      dir = Dir.pwd
      while(dir != '/')
        if File.exists? File.join(dir, CONFIG_NAME)
          c = YAML.load_file(File.join(dir, CONFIG_NAME)).deep_merge!(c)
        end
        dir = File.dirname(dir)
      end
      if c.empty? && File.exists?(home_config)
        c = YAML.load_file(home_config)
      end
      c
    end
  end
end
