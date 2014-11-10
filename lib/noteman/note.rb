module Noteman
	class Note
		include MDProcessor
		attr_accessor :content, :metadata, :tags, :body, :file

		def initialize(file)
			@file = file
			@content = File.read file
			@metadata = get_metadata @content
			@body = remove_metadata @content
		end
    
    def tags
      @tags = []
			if metadata and metadata['tags']
        @tags = metadata['tags']
      end
      @tags
    end

		def with_tags?(tags)
			if metadata and metadata['tags']
				if (tags - metadata['tags']).empty?
					return true
				end
			end
			false
		end

		def contains?(keywords)
			keywords.all? { |word| body.downcase.include? word.downcase }
		end
	end
end
