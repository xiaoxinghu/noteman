module Noteman
  class NoteManager
    include Config
    attr_accessor :notes, :result, :tags

    def initialize
      @notes = []
      Dir.chdir(File.expand_path(config['notes_in']))
      Dir.glob("*.#{config['ends_with']}").each do |file|
        @notes << Note.new(file)
      end
    end

    def self.search
      @@manager = NoteManager.new unless defined? @@manager
      @@manager.reset_filter
    end

    def reset_filter
      @result = []
      @result += @notes
      self
    end

    def by_tags(tags)
      if tags && tags.length > 0
        @result.delete_if { |note| not note.with_tags? tags }
      end
      self
    end

    def by_keywords(keywords)
      if keywords && keywords.length > 0
        @result.delete_if { |note| not note.contains? keywords }
      end
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

    def capture(input, link=nil)
      if link
        content = "[#{input}](#{link})"
      else
        content = input
      end
      open(config['capture_to'], 'a') do |f|
        f << "#{content}\n"
      end
    end

    def inbox
      notes.select { |n| n.file == config['capture_to'] }.first
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

    def tags
      if not defined? @tags
        @tags = {}
        notes.each do |note|
          note.tags.each do |tag|
            if not @tags.has_key? tag
              @tags[tag] = 1
            else
              @tags[tag] += 1
            end
          end
        end
      end
      @tags
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
