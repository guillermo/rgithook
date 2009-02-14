require 'rgithook/rgithook/base'
require 'rgithook/rgithook/installation'
require 'rgithook/rgithook/editor'
require 'rgithook/rgithook/hooks'

module RGitHook
   class RGitHook
      attr_reader :repo, :runner

      include ::RGitHook::Base
      include ::RGitHook::Installation
      include ::RGitHook::Editor
      include ::RGitHook::Hooks


      
      # def fetch
      #   in_repo_dir do
      #     %x(git fetch)
      #   end
      # end
      # 
      # def in_repo_dir
      #   old_dir = Dir.pwd
      #   Dir.chdir @repo.bare ? @repo.path : @repo.working_tree
      #   ret_val = yield
      #   Dir.chdir old_dir
      #   ret_val
      # end
   end
end
