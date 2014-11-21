require 'tempfile'

Gem.find_files("noteman/**/*.rb").each do |f| 
  require f
end

Dir["#{Dir.home}/.noteman/plugins/*.rb"].each do |f|
  require f
end

module Noteman
end
