require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'cucumber'
require 'cucumber/rake/task'

spec = eval(File.read('noteman.gemspec'))
Gem::PackageTask.new(spec) do |pkg|
end

CUKE_RESULTS = 'results.html'
CLEAN << CUKE_RESULTS
desc 'Run features'
Cucumber::Rake::Task.new(:features) do |t|
  opts = "features --format html -o #{CUKE_RESULTS} --format progress -x"
  opts += " --tags #{ENV['TAGS']}" if ENV['TAGS']
  t.cucumber_opts =  opts
  t.fork = false
end

desc 'Run features tagged as work-in-progress (@wip)'
Cucumber::Rake::Task.new('features:wip') do |t|
  tag_opts = ' --tags ~@pending'
  tag_opts = ' --tags @wip'
  t.cucumber_opts = "features --format html -o #{CUKE_RESULTS} --format pretty -x -s#{tag_opts}"
  t.fork = false
end

task :cucumber => :features
task 'cucumber:wip' => 'features:wip'
task :wip => 'features:wip'
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
end

desc 'Install the gem in the current ruby'
task :install, :all do |t, args|
  args.with_defaults(:all => false)
  if args[:all]
    sh "rvm all do gem install pkg/*.gem"
    sh "sudo gem install pkg/*.gem"
  else
    sh "gem install pkg/*.gem"
  end
end

desc 'Development version check'
task :ver do |t|
  system "grep VERSION lib/noteman/version.rb"
end

task :default => [:test,:features]
task :build => [:clobber,:package]
