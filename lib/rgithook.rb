$:.unshift File.dirname(__FILE__)

begin

   module RGitHook
      VERSION='3.0.2'
      PATH=File.dirname(File.expand_path(__FILE__))
   end

   require 'rubygems'
   gem 'mojombo-grit'
   require 'grit'

   require File.join('rgithook', 'runner')
   
   require File.join('rgithook', 'rgithook')
   require File.join('rgithook', 'hook')
   RGitHook.autoload(:Plugin, File.join(RGitHook::PATH,'rgithook','plugin'))
   RGitHook.autoload(:CommandLine, File.join(RGitHook::PATH,'rgithook','command_line'))

   Dir.glob(File.join(File.dirname(__FILE__),'plugins','*.rb')).each do |plugin|
      begin
         require plugin
      rescue LoadError => e
         puts "Failed to load some plugin #{plugin}\n#{e.to_s}"
      end
   end


rescue LoadError => e
   puts 'Imposible to load some gem'
   puts e.message
   exit -1
end


