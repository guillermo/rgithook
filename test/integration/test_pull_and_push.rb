require File.dirname(__FILE__)+'/../test_helper'


class FetchPullPushTest < RGitHook::TestCase
  
  def test_a_default_installation
    with_sample_rgithook do |rgithook1|      
      in_temp_dir do |dir|
        %x(git clone #{rgithook1.path} sample_test #{without_output})
        Dir.chdir 'sample_test'
        %x(touch asdf && git add . && git commit -m 'adf' #{without_output})
        push_result = %x(git push 2> /dev/null)
        assert_equal $?.to_i, 0, "Error:\n#{push_result}"
      end
    end
  end
  
  def test_fetch_command
    with_sample_rgithook do |rgithook1|
      rgithook1.install(false)
      
      in_temp_dir do |dir|
        %x(git clone #{rgithook1.path} sample_test #{without_output})
        Dir.chdir rgithook1.path
        %x( echo #{rand} >> asdf ; git add . #{without_output} ; git commit -a -m 'asdf updated' #{without_output})
        Dir.chdir dir+'/sample_test'
        rgithook2 = RGitHook::RGitHook.new('.')
        rgithook2.install(false)
        rgithook2.fetch
      end
    end
  end
  
end
