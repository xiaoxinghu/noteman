require 'dropbox_sdk'
require 'fileutils'
require 'pp'

module Noteman
  module Dropbox
    include Config
    APP_KEY = ''
    APP_SECRET = ''

    def sync
      state = load_state
      # auth
      if not state['access_token']
        web_auth = DropboxOAuth2FlowNoRedirect.new(APP_KEY, APP_SECRET)
        authorize_url = web_auth.start()
        puts "1. Go to: #{authorize_url}"
        puts "2. Click \"Allow\" (you might have to log in first)."
        puts "3. Copy the authorization code."

        print "Enter the authorization code here: "
        STDOUT.flush
        auth_code = STDIN.gets.strip

        access_token, user_id = web_auth.finish(auth_code)
        puts "Link successful."
        state['access_token'] = access_token
      end

      cursor = state['cursor']
      access_token = state['access_token']
      c = DropboxClient.new(access_token)
      result = c.delta cursor, config['dropbox_path']
      pp result
      #save_state state
    end

  end
end
