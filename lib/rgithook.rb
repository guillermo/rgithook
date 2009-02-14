$:.unshift File.dirname(__FILE__)
require 'rubygems'
gem 'mojombo-grit'; require 'grit'


module RGitHook
  Version=File.read(File.dirname(__FILE__)+'/../CHANGELOG')[/(v\d\.\d\.\d) /,1]
  
  #Since these gem use Dir.pwd it must save the location of the files at start up
  PATH=File.dirname(File.expand_path(__FILE__))
  HOOKS = %w(applypatch_msg commit_msg post_commit post_receive post_update
    pre_applypatch pre_commit pre_rebase prepare_commit_msg  update)
    
  require 'rgithook/runner'
  require 'rgithook/rgithook'
  
  self.autoload(:Hook, File.join(PATH,'rgithook', 'hook'))
  self.autoload(:CommandLine, File.join(PATH,'rgithook','command_line'))

end

