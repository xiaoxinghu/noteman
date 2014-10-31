require File.join(File.dirname(__FILE__), 'lib', 'noting', 'version.rb')
spec = Gem::Specification.new do |s|
	s.name = 'noting'
	s.version = Noting::VERSION
	s.author = 'Xiaoxing Hu'
	s.email = 'dawnstar.hu@gmail.com'
	s.files = %w(
	bin/noting
	lib/noting/version.rb
	lib/noting.rb
	lib/noting/noteman.rb
	)
	s.summary = 'You advanced note manager.'

	s.bindir = 'bin'
	s.executables << 'noting'
end
