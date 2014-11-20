require 'dropbox_sdk'
require 'fileutils'

module Noteman
  module Dropbox
    STATE_FILE = 'state.json'
    def sync
      FileUtils.mkdir_p NOTEMAN_HOME
    end

    def load_state
    end
  end
end
