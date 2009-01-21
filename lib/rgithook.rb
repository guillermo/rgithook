$:.unshift File.dirname(__FILE__)
begin
  require 'erb'
  require 'fileutils'
  
  require 'rubygems'
  gem 'mojombo-grit'
  require 'grit'
  
  require File.join('rgithook', 'runner')
  require File.join('rgithook', 'commands')
  require File.join('rgithook', 'hook')
  require File.join('rgithook', 'rgithook')
  RGitHook.autoload(:Plugin, File.join('rgithook','plugin'))
  RGitHook.autoload(:CommandLine, File.join('rgithook','command_line'))

  Dir.glob(File.join(File.dirname(__FILE__),'plugins','*.rb')).each do |plugin|
    begin
      require plugin
    rescue LoadError => e 
      puts "Failed to load #{plugin}\n#{e.to_s}"
    end
  end
  
  module RGitHook
    VERSION='3.0.0'
  end

rescue LoadError => e
  puts 'Imposible to load some gem'
  puts e.message
  exit -1
end


