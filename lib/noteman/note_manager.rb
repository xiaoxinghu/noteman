module Noteman
	class NoteManager
		include Config

		attr_accessor :notes, :result

		def initialize
			@notes = []
			Dir.chdir(File.expand_path(config['notes_in']))
			Dir.glob("*.#{config['ends_with']}").each do |file|
				@notes << Note.new(file)
			end
		end

		def search
			@result = @notes
			self
		end

		def by_tags(tags)
			@result.delete_if { |note| not note.with_tags? tags }
			self
		end

		def by_keywords(keywords)
			@result.delete_if { |note| not note.contains? keywords }
			self
		end

		def search_by_fomular(name)
			fomular = config['fomular'][name]
			if fomular
				search
				tags = fomular['tags'].split(' ')
				keywords = fomular['keywords'].split(' ')
				if tags
					by_tags tags
				end
				if keywords
					by_keywords keywords
				end
			else
				puts "No such fomular defined #{name}."
			end
			self
		end

		def choose(notes)
			if notes.length > 1
				notes.each_with_index do |note, i|
					puts "% 3d: %s" % [i, note.file]
				end
				print "> "
				num = STDIN.gets
				return false if num =~ /^[a-z ]*$/i
				chosen = notes[num.to_i]
			elsif notes.length == 1
				chosen = notes[0]
			else
				chosen = false
			end
			chosen
		end

		def view(file)
			system("open -a \"#{config['view_with']}\" #{file}")
		end

		def view_result
			chosen = choose result
			view chosen.file
		end

		def fork_editor(input="")
			tmpfile = Tempfile.new('note')

			File.open(tmpfile.path,'w+') do |f|
				f.puts input
			end

			pid = Process.fork { system("$EDITOR #{tmpfile.path}") }

			trap("INT") {
				Process.kill(9, pid) rescue Errno::ESRCH
				tmpfile.unlink
				tmpfile.close!
				exit 0
			}

			Process.wait(pid)

			begin
				if $?.exitstatus == 0
					input = IO.read(tmpfile.path)
				else
					raise "Cancelled"
				end
			ensure
				tmpfile.close
				tmpfile.unlink
			end

			input
		end
	end
end
