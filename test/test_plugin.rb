require 'test_helper'




class TestPlugin < Test::Unit::TestCase
  include RGitHook

  class SamplePlugin < ::RGitHook::Plugin
    option :test_option, 'Test Option description', :default_value, Symbol
    option_group :test_group, 'Test Option group' do |opt_group|
      opt_group.option :test_option_group_option, 'Test OptionGroup Option', :default_value, Symbol
    end

    module RunnerMethods
      def test_method
        'test_result'
      end
    end

    module GritCommit
      def test_method
      end
    end
  end
  
  def setup
    options = {:SamplePlugin => {:test_option=>:load_value, :test_group=>{:test_option_group_option=>:load_value}}}
    File.stubs(:read).with(Plugin::CONF_FILE).returns(options.to_yaml)
    
  end

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

  def test_options
    assert_raise(::NoMethodError) {
      assert_equal Plugin[:SamplePlugin][:test_option],:default_value
    }
  end

  def test_getter
    Plugin.load!
    assert_equal SamplePlugin[:test_option],:load_value
    assert_equal SamplePlugin[:test_group][:test_option_group_option],:load_value
    assert_raise(Plugin::NoOptionError){
      SamplePlugin[:unknow_option]
    }
    assert_raise(Plugin::NoOptionError){
      SamplePlugin[:test_group][:unknow_option]
    }
  end

  def test_setter
    Plugin.load!
    SamplePlugin[:test_option]=:setter_value
    SamplePlugin[:test_group][:test_option_group_option]=:setter_value
    assert_equal SamplePlugin[:test_option],:setter_value
    assert_equal SamplePlugin[:test_group][:test_option_group_option],:setter_value
    assert_raise(Plugin::NoOptionError){
      SamplePlugin[:unknow_option]=88
    }
    assert_raise(Plugin::NoOptionError){
      SamplePlugin[:test_group][:unknow_option]=99
    }

  end

  def test_load!
    assert_nothing_raised{
      Plugin.load!
    }
    assert_equal SamplePlugin[:test_option],:load_value
    assert_equal SamplePlugin[:test_group][:test_option_group_option],:load_value    
  end

  def test_reset_defaults!
    Plugin.load!
    Plugin.reset_defaults!

    assert_equal SamplePlugin[:test_option],:default_value
    assert_equal SamplePlugin[:test_group][:test_option_group_option],:default_value
  end

  def test_plugin_reset_defaults!
    Plugin.load!
    
    SamplePlugin[:test_option] = 10
    SamplePlugin[:test_group][:test_option_group_option] = 10

    SamplePlugin.reset_defaults!

    assert_equal SamplePlugin[:test_option],:default_value
    assert_equal SamplePlugin[:test_group][:test_option_group_option],:default_value
  end
  
  
  class << self
    attr_accessor :string_buffer # Used to read IO.write in test_save!
  end
  
  def test_save!
    Plugin.load!
    
    SamplePlugin[:test_option]= :save_option
    SamplePlugin[:test_group][:test_option_group_option]=:save_option
    
    file = mock('IO::Mock')
    
    class << file
      def write(str)
        TestPlugin.string_buffer = str
      end
    end
    File.expects(:new).with(Plugin::CONF_FILE,'w').returns(file)
    
    Plugin.save!
    saved_options = {:test_option=>:save_option, :test_group=>{:test_option_group_option=>:save_option}}
    assert_equal YAML.load(self.class.string_buffer)[:SamplePlugin], saved_options
  end

  
end
