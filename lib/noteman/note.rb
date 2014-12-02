module Noteman
  class Note
    include MDProcessor, Config
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

    def view
      system("open -a \"#{config['view_with']}\" #{file}")
    end

  end
end
