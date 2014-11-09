module Noteman
	class Note
		include MDProcessor
		attr_accessor :content, :metadata, :body, :file

		def initialize(file)
			@file = file
			@content = File.read file
			@metadata = get_metadata @content
			@body = remove_metadata @content
		end

		def with_tags?(tags)
			if metadata['tags']
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
