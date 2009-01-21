require 'test_helper'

module RGitHook

  class RunnerTest < Test::Unit::TestCase
    def setup
      @repo = mock('grit_repo')
      @repo.stubs(:'is_a?').with(::Grit::Repo).returns(true)    
    end
    
    def test_new
      assert_raise ArgumentError do
        Runner.new('.')
      end
      
      repo = mock('grit_repo')
      repo.expects(:'is_a?').with(::Grit::Repo).returns(true)
      assert_nothing_raised do
        Runner.new repo
      end
      
      assert_instance_of Runner, Runner.new(@repo)
    end
    
    def test_on
      assert_raise(ArgumentError) { Runner.new(@repo).on(:false_hook ) {}; }
      assert_nothing_raised { Runner.new(@repo).on(HOOKS.first.to_sym) {}; }
    end
    
    
    def test_hooks
      hook = HOOKS.first.to_sym
      runner = Runner.new @repo
      
      mock = mock('test_class', :meth1 => 'meth1',:meth2 => 'meth2')
      runner.expects(:fork).times(2).returns(20)

      runner.on(hook) {mock.meth1}
      runner.on(hook) {mock.meth2}

      runner.on(hook, :background => true) {mock.meth1}
      runner.on(hook, :background => true) {mock.meth2}

      assert_equal runner.run_hooks(hook), [['meth1','meth2'],[20,20]]

    end
    
    def test_foreground_hooks
      hook = HOOKS.first.to_sym
      runner = Runner.new @repo
      
      mock = mock('test_class', :meth1 => 'meth1',:meth2 => 'meth2')
      
      runner.on(hook) {mock.meth1}
      runner.on(hook) {mock.meth2}
      
      assert_equal runner.run_foreground_hooks(hook), ['meth1','meth2']
    end
    
    def test_background_hooks
      hook = HOOKS.first.to_sym
      runner = Runner.new @repo
      
      
      runner.expects(:fork).times(2).returns(20)
      runner.on(hook, :background => true) {mock.meth1}
      runner.on(hook, :background => true) {mock.meth2}
      
      assert_equal runner.run_background_hooks(hook), [20,20]
    end
    
  end
  
end


    # 
    # def run_hooks(hook_name, *args)
    #   @hooks[hook_name.to_sym] && @hooks[hook_name.to_sym].each do |hook|
    #     hook.call(*args)
    #   end
    # end
    # 
    # 
    # def repo
    #   @repo
    # end
    # 
