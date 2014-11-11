require 'curses'

module Noteman
  module UI
    include Curses

    def test_window
      init_screen
      cbreak

      search_box = Window.new(3, 40, 7 ,2)
      search_box.box('|', '-')
      search_box.setpos(1, 1)
      text = ''
      while ch = search_box.getch
        case ch
        when 10 # enter
          break
        when 127 # backspace
        else
          if ch.is_a? String
            search_box.addch ch
          end
        end
      end
    end

    def input(menu, text)
      menu.setpos(1, 1)
      menu.addstr text
    end
  end
end
