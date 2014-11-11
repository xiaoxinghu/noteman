require 'curses'

module Noteman
	module UI
		include Curses

		def find_note
			init_screen
			noecho

			search_box = Window.new(3, cols, 0 ,0)
			draw_search_box search_box

			result_box = Window.new(30, cols, 3 ,0)
			draw_result_box result_box

			@@message_box = Window.new(3, cols, 40 ,0)

			text = ''
			selected = 0
			while ch = search_box.getch
				case ch
				when 10 # enter
					break
				when 127 # backspace
					if text.length > 0
						text = text.slice(0, text.length - 1)
					end
				when "[A" # arrow up
					draw_message_box @@message_box, 'up pressed'
					selected -= 1
				when "\e[B" # arrow down
					draw_message_box @@message_box, 'down pressed'
					selected += 1
				else
					if ch.is_a? String
						text += ch
					end
					draw_message_box @@message_box, "#{text.split}"
				end
				draw_search_box search_box, text
				notes = Noteman::NoteManager.search.by_keywords text.split
				#draw_message_box message_box, "#{notes.result.length}"
				draw_result_box result_box, notes.result, 0
			end
			close_screen
			return text
		end

		def draw_search_box(search_box, text='')
			search_box.clear
			search_box.box('|', '-')
			search_box.setpos(1, 1)
			search_box.addstr text
			search_box.refresh
		end

		def draw_result_box(result_box, results=[], selected_index=1)
			#result_box.box('|', ' ')
			result_box.clear
			results.each_with_index do |n, i|
				result_box.setpos(i+1, 1)
				result_box.attrset(i == selected_index ? A_STANDOUT : A_NORMAL)
				#draw_message_box @@message_box, "#{i} #{n.file}"
				result_box.addstr "#{i}> #{n.file}"
			end
			result_box.refresh
		end

		def draw_message_box(message_box, text='')
			message_box.clear
			message_box.box('|', '-')
			message_box.setpos(1, 1)
			message_box.addstr text
			message_box.refresh
		end
	end
end
