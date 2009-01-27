module OtherApp
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

end