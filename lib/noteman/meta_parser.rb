module Noteman
	class MetaParser
		def self.get_metadata(text)
			text =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
			meta = YAML.load($1) if $1
		end
	end
end
