require 'redcarpet'
require 'deep_merge'
require 'noteman/meta_parser'

module Noteman
	class BaseMan
		attr_accessor :config

		CONFIG_NAME = ".notemanrc"
		def initialize
			@config = read_config
			@config['path'] ||= "~/io"
			@config['viewer'] ||= "Marked 2"
			@config['editor'] ||= "vim"
			@config['inbox'] ||= "inbox.md"
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
