module Noteman
  class CheatMan
    include NoteManager

    def show(*tags)
      t = ['cheatsheet'] + tags
      sheets = search_by_tags *t

      sheet = choose sheets
      view sheet
    end

    def output(file)
      md = get_md File.read(file)
      puts md
    end
  end
end
