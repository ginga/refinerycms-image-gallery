# encoding: utf-8

require 'psych'
require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "refinerycms-image-gallery"
  gem.homepage = "http://github.com/ginga/refinerycms-image-gallery"
  gem.license = "MIT"
  gem.summary = "Multi-purpose image-gallery for RefineryCMS."
  gem.description = "Image Gallery for RefineryCMS that supports another fields like author, subtitles etc."
  gem.email = "mvinicius.zago@gmail.com"
  gem.authors = ["Vinicius Zago"]
  gem.executables = ["refinerycms_image_gallery"]
  gem.files.include 'lib/templates/**/*'
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :test

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "refinerycms-image-gallery #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end