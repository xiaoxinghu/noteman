module Noteman
  module Display
    include Config

    def output_tags(tags)
      tags.keys.each do |tag|
        puts "#{tag} (#{tags[tag]})"
      end
    end
  end
end
