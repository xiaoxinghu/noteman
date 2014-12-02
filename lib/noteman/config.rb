require 'deep_merge'

module Noteman
  module Config
    NOTEMAN_CONFIG = File.join(Dir.home, '.notemanrc')
    attr_reader :config

    def config
      if not defined? @config
        @config = read_from_file
        @config['notes_in'] ||= "~/notes"
        @config['view_with'] ||= "Marked 2"
        @config['capture_to'] ||= "capture.md"
        @config['ends_with'] ||= "md"
        @config['home'] ||= "~/.noteman"
        # @config['state_file'] ||= "state.json"
        # @config['dropbox_path'] ||= "/notes"
        # @config['fomula'] ||= {}
        # @config['fomula']['cheatsheets'] ||= {
        #   'tags' => 'cheatsheet'
        # }
        # @config['fomula']['drafts'] ||= {
        #   'tags' => 'draft post',
        #   'tags_bool' => 'AND'
        # }

        File.open(NOTEMAN_CONFIG, 'w') { |yf| YAML::dump(config, yf) }
        FileUtils.mkdir_p @config['home']
      end
      @config
    end

    def read_from_file
      c = {}
      if c.empty? && File.exists?(NOTEMAN_CONFIG)
        c = YAML.load_file(NOTEMAN_CONFIG)
      end
      c
    end
  end
end
