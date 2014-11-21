module Noteman
  module Dropbox
    include Config

    def state_file
      File.join File.expand_path(config['home']), config['state_file']
    end

    def load_state
      if File.exist? state_file
        state = JSON.parse(File.read(state_file), :max_nesting => false)
        state['tree'] = Node.from_json_content(state['tree'])
      else
        state = {
          'tree' => {}
        }

        save_state state
      end
      state
    end

    def save_state(state)
      state['tree'] = Node.to_json_content(state['tree'])
      File.open(state_file,"w") do |f|
        f.write(JSON.pretty_generate(state, :max_nesting => false))
      end
    end

    # We track folder state as a tree of Node objects.
    class Node
      attr_accessor :path, :content
      def initialize(path, content)
        # The "original" page (i.e. not the lower-case path)
        @path = path
        # For files, content is a pair (size, modified)
        # For folders, content is a hash of children Nodes, keyed by lower-case file names.
        @content = content
      end
      def folder?()
        @content.is_a? Hash
      end
      def to_json()
        [@path, Node.to_json_content(@content)]
      end
      def self.from_json(jnode)
        path, jcontent = jnode
        Node.new(path, Node.from_json_content(jcontent))
      end
      def self.to_json_content(content)
        if content.is_a? Hash
          map_hash_values(content) { |child| child.to_json }
        else
          content
        end
      end
      def self.from_json_content(jcontent)
        if jcontent.is_a? Hash
          map_hash_values(jcontent) { |jchild| Node.from_json jchild }
        else
          jcontent
        end
      end
    end

    # Run a mapping function over every value in a Hash, returning a new Hash.
    def map_hash_values(h)
      new = {}
      h.each { |k,v| new[k] = yield v }
      new
    end

  end
end
