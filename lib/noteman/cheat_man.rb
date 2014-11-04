require 'noteman/base_man'

module Noteman
  class CheatMan < BaseMan

    def show(*tags)
      t = ['cheatsheet'] + tags
      sheets = search_by_tags *t

      sheets.each do |s|
        view s
      end
    end

    def view(file)
      system("open -a \"#{@config['viewer']}\" #{file}")
    end
  end
end
