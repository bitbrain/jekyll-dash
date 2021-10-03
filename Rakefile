# coding: utf-8
require 'jekyll'
require 'rake/release/task'

# Extend string to allow for bold text.
class String
  def bold
    "\033[1m#{self}\033[0m"
  end
end

# Rake Jekyll tasks
task :build do
  puts 'Building site...'.bold
  Jekyll::Commands::Build.process(profile: true)
end

task :clean do
  puts 'Cleaning up _site...'.bold
  Jekyll::Commands::Clean.process({})
end

Rake::Release::Task.new do |spec|
  spec.sign_tag = true
end

task :default => :build
