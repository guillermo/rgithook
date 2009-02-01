require File.dirname(__FILE__)+'/../test_helper'


class FetchPullPushTest < Test::Unit::TestCase
  
  def test_a_default_installation
    with_sample_rgithook do |rgithook1|
      rgithook1.install(false)
      
      in_temp_dir do |dir|
        %x(git clone #{rgithook1.path} sample_test)
        Dir.chdir 'sample_test'
        %x(touch asdf && git add . && git commit -m 'adf')
        push_result = %x(git push)
        assert_equal $?.to_i, 0, "Error:\n#{push_result}"
      end
    end
    
  end
end
