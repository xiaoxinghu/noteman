module Noteman
  module NoteManager
    include Config, MDProcessor

    def search_by_tags(*tags)
      results = []
      Dir.chdir(File.expand_path(config['notes_in']))
      Dir.glob("*.#{config['ends_with']}").each do |file|
        metadata = get_metadata File.read(file)
        if metadata and metadata['tags']
          if (tags - metadata['tags']).empty?
            results << file
          end
        end
      end
      results
    end

    def choose(items)
      if items.length > 1
        items.each_with_index do |item, i|
          puts "% 3d: %s" % [i, item]
        end
        print "> "
        num = STDIN.gets
        return false if num =~ /^[a-z ]*$/i
        result = items[num.to_i]
      elsif items.length == 1
        result = items[0]
      else
        result = false
      end
      result
    end

    def view(file)
      system("open -a \"#{config['view_with']}\" #{file}")
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
