require 'deep_merge'

module Noteman
  module Config
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

        File.open(Noteman::NOTEMAN_CONFIG, 'w') { |yf| YAML::dump(config, yf) }
      end
      @config
    end

    def read_from_file
      c = {}
      if c.empty? && File.exists?(Noteman::NOTEMAN_CONFIG)
        c = YAML.load_file(Noteman::NOTEMAN_CONFIG)
      end
      c
    end
  end
end
