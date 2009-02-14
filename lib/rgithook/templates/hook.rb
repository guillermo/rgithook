#!/usr/bin/env ruby

require 'rubygems'
begin
  require 'rgithook'
  exit RGitHook::Hook.execute

rescue LoadError
  puts 'WARNING: RGitHook gem not installed. No rgithooks runned.'
end

exit 0