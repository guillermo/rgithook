require File.dirname(__FILE__)+'/../test_helper'


module RGitHook
   class HookTest < Test::Unit::TestCase

      def test_self_execute
         $0 = 'potatos-super-hook'
         Hook.expects(:puts).with('Executing potatos-super-hook hook')
         Hook.expects(:potatos_super_hook)
         Hook.execute
      end


      def test_post_receive

         repo = mock('grit_repo')
         repo.stubs(:path).returns('path')
         RGitHook.stubs(:parse_path).with(:repo).returns(repo)
         Hook.expects(:repo_path).at_least_once.returns('repo_path')

         rgithook = mock()
         RGitHook.expects(:new).with('repo_path').returns(rgithook)
         STDIN.expects(:read).returns("aaaa bbbb ref1\ncccc dddd ref2\n")

         rgithook.expects(:post_receive).with('aaaa','bbbb','ref1').returns( [['meth1','5'],[20,20]])
         rgithook.expects(:post_receive).with('cccc','dddd','ref2').returns( [['6',7],[20,20]])
         assert_equal Hook.post_receive, 7
      end
   end
end
