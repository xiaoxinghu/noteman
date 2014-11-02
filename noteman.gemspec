require File.join(File.dirname(__FILE__), 'lib', 'noteman', 'version.rb')
spec = Gem::Specification.new do |s|
	s.name = 'noteman'
	s.version = Noting::VERSION
	s.author = 'Xiaoxing Hu'
	s.email = 'dawnstar.hu@gmail.com'
	s.platform = Gem::Platform::RUBY
	s.summary = 'You advanced note manager.'
	s.description = 'A tool for managing your markdown notes.'
	s.license = 'MIT'
	s.files = %w(
	bin/note
	lib/noteman/version.rb
	lib/noteman.rb
	lib/noteman/noteman.rb
	)
	s.bindir = 'bin'
	s.executables << 'note'

	s.add_runtime_dependency('gli', '2.12.2')
  s.add_runtime_dependency('deep_merge')
end
