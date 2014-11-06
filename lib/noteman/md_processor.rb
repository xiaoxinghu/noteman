require 'redcarpet'
module Noteman
  module MDProcessor
    class StackRenderer < Redcarpet::Render::Base
      attr_reader :items

      def initialize
        super
        @items = []
      end

      def header(title, level)
        items << { :text => title, :level => level, :type => :header }
        "#{'#' * level} #{title}\n\n"
      end

      def paragraph(text)
        items << { :text => text, :type => :paragraph }
        "#{text}\n\n"
      end

    end

    def get_metadata(text)
      text =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
      meta = YAML.load($1) if $1
    end

    def remove_metadata(text)
      text.sub /^(---\s*\n.*?\n?)^(---\s*$\n?)/m, ''
    end

    def get_md(text)
      sr = StackRenderer.new
      md = Redcarpet::Markdown.new(sr)

      md.render(remove_metadata text)
      sr.items
    end
  end
end
