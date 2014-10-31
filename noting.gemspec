require File.join(File.dirname(__FILE__), 'lib', 'noting', 'version.rb')
spec = Gem::Specification.new do |s|
	s.name = 'noting'
	s.version = Noting::VERSION
	s.author = 'Xiaoxing Hu'
	s.email = 'dawnstar.hu@gmail.com'
	s.platform = Gem::Platform::RUBY
	s.summary = 'You advanced note manager.'
	s.description = 'A tool for managing your markdown notes.'
	s.license = 'MIT'
	s.files = %w(
	bin/note
	lib/noting/version.rb
	lib/noting.rb
	lib/noting/noteman.rb
	)
	s.bindir = 'bin'
	s.executables << 'note'
end
