require 'curses'

module Noteman
	class Finder
		include Curses

		def initialize
			@opend = false
		end

		def open
			if @opened
				return self
			end
			init_screen
			cbreak
			noecho
			raw
			@search_box = Window.new(3, cols, 0 ,0)
			@search_box.keypad = true
			draw_search_box

			@result_box = Window.new(30, cols, 3 ,0)
			draw_result_box

			@message_box = Window.new(3, cols, 40 ,0)
			draw_message_box

			@opened = true
			self
		end

		def close
			@opened = false
			close_screen
		end

		def find_note
			begin
				open
				text = ''
				selected = 0
				notes = []
				while true
					ch = @search_box.getch
					case ch
					when KEY_RESIZE
						next
					when 10 # enter
						break
					when 127 # backspace
						if text.length > 0
							text = text.slice(0, text.length - 1)
						end
					when KEY_UP #arrow up
						#selected -= 1
						selected == 0 ? selected = notes.length - 1 : selected -= 1
					when KEY_DOWN #arrow down
						selected == notes.length - 1 ? selected = 0 : selected += 1
					else
						if ch.is_a? String
							text += ch
						end
					end
					draw_search_box text
					tags = []
					keywords = []
					text.split.each do |t|
						if t.start_with? '@' and t.length > 1
							tags << t.tr('@', '')
						else
							keywords << t
						end
					end
					notes = NoteManager.search.by_tags(tags).by_keywords(keywords).result
					draw_result_box notes, selected
				end
				notes[selected]
			ensure
				close
			end
		end

		def draw_search_box(text='')
			@search_box.clear
			@search_box.box('|', '-')
			@search_box.setpos(1, 1)
			@search_box.addstr text
			@search_box.refresh
		end

		def draw_result_box(results=[], selected_index=0)
			@result_box.clear
			results.each_with_index do |n, i|
				@result_box.setpos(i+1, 1)
				@result_box.attrset(i == selected_index ? A_STANDOUT : A_NORMAL)
				@result_box.addstr "#{n.file}"
			end
			@result_box.refresh
		end

		def draw_message_box(text='')
			@message_box.clear
			@message_box.setpos(1, 1)
			@message_box.addstr "#{text}"
			@message_box.refresh
		end
	end
end
