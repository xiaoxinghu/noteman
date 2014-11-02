require 'deep_merge'

class Noteman
	attr_accessor :config

	def initialize
		@config = read_config
    @config['notes_folder'] ||= "~/notes"
    @config['inbox'] ||= "inbox.md"
		@config['default_extention'] = "md"
    File.open(home_config, 'w') { |yf| YAML::dump(config, yf) }
	end

	def hi
		puts 'Hi, I am Noteman.'
	end

  def home_config
    if Dir.respond_to?('home')
      File.join(Dir.home, NOTEMAN_CONFIG_NAME)
    else
      File.join(File.expand_path("~"), NOTEMAN_CONFIG_NAME)
    end
  end

  def read_config
    config = {}
    dir = Dir.pwd
    while(dir != '/')
      if File.exists? File.join(dir, NOTEMAN_CONFIG_NAME)
        config = YAML.load_file(File.join(dir, NOTEMAN_CONFIG_NAME)).deep_merge!(config)
      end
      dir = File.dirname(dir)
    end
    if config.empty? && File.exists?(home_config)
      config = YAML.load_file(home_config)
    end
    config
  end
end
