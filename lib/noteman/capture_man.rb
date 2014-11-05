module Noteman
  class CaptureMan
    include NoteManager
    def capture(note)
      puts note
    end
  end
end
