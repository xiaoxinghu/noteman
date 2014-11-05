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
