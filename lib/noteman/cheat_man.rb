module Noteman
  class CheatMan
    include NoteManager

    def show(*tags)
      t = ['cheatsheet'] + tags
      sheets = search_by_tags *t

      sheets.each do |s|
        view s
      end
    end

    def view(file)
      system("open -a \"#{config['view_with']}\" #{file}")
    end
  end
end
