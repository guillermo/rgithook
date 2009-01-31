require File.dirname(__FILE__)+'/../test_helper'


class TestPlugin < Test::Unit::TestCase
   include RGitHook

   # def setup
   #   options = {:SamplePlugin => {:test_option=>:load_value, :test_group=>{:test_option_group_option=>:load_value}}}
   #   File.stubs(:read).with(Plugin::CONF_FILE).returns(options.to_yaml)
   # end

   def test_runner_methods
      repo = mock_repo
      Plugin.load!
      runner = Runner.new(repo)
      assert_equal runner.test_method, 'test_result'
   end

   def test_grit_commit_methods
      Plugin.load!
      assert ::Grit::Commit.instance_methods.include?("test_method"), 'Plugin::GritCoomit is not included in Grit::Commit'
   end

   def test_options_to_hash
      options = Plugin.options_to_hash[:SamplePlugin]
      assert_equal options[:test_option], :default_value
      assert_equal options[:test_group][:test_option_group_option], :default_value
   end

   def test_load!
      assert_nothing_raised{
         Plugin.load!
      }
   end

end
