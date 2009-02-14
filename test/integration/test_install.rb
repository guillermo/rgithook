require File.dirname(__FILE__)+'/../test_helper'

class IntegrationTest < RGitHook::TestCase

   def test_inastall_without_confirmation
      in_sample_repo do
         @repo = ::RGitHook::RGitHook.new('.')
         @repo.install(false)
         assert File.file?('.git/hooks/rgithook.rb')
         assert File.file?('.git/hooks/applypatch-msg')
         assert File.file?('.git/hooks/commit-msg')
         assert File.file?('.git/hooks/post-commit')
         assert File.file?('.git/hooks/post-receive')
         assert File.file?('.git/hooks/post-update')
         assert File.file?('.git/hooks/pre-applypatch')
         assert File.file?('.git/hooks/pre-commit')
         assert File.file?('.git/hooks/pre-rebase')
         assert File.file?('.git/hooks/prepare-commit-msg')
         assert File.file?('.git/hooks/update')
      end
   end

   def test_simple_hook
      with_sample_rgithook do
         File.open(@rgithook.hooks_file,'w') do |f|
        hook_file =<<-EOF
        on :post_receive do |old_commit,new_commit,ref|
          %x(touch \#{old_commit})
          %x(touch \#{new_commit})
          %x(touch \#{ref})
        end
        
        on :pre_commit do
          %x(rm a b c)
        end
            EOF
            f.write(hook_file)
         end

         @rgithook = RGitHook::RGitHook.new('.')
         @rgithook.post_receive('a','b','c')
         assert File.file?('a')
         assert File.file?('b')
         assert File.file?('c')
         @rgithook.pre_commit
         assert !File.file?('a')
         assert !File.file?('b')
         assert !File.file?('c')
      end
   end

   def test_project_name
      with_sample_rgithook do
         assert_match /^rgithook-(.*)/, @rgithook.project_name
      end
   end

end
