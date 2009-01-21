require 'test_helper'

module RGitHook

  class RGitHookTest < Test::Unit::TestCase
    def setup
      runner = mock('runner')
      runner.stubs(:binding)
      Runner.stubs(:new).returns(runner)
    end

    def test_class_install
        repo = mock('grit_repo')
        repo.stubs(:path).returns('path')
        ::Grit::Repo.stubs(:new).with(:repo).returns(repo)  
        
        RGitHook.expects(:prompt).with('All active hooks will be erase. Continue?').once.returns(true)
        FileUtils.stubs(:mkdir).with('path/hooks')
        File.expects(:'exist?').with('path/hooks')
        RGitHook.expects(:install_template).at_least(4)
        RGitHook.expects(:parse_path).with(:repo).returns(repo)
        RGitHook.install(:repo)
    end

    def test_install
        repo = mock('grit_repo')
        repo.stubs(:path).returns('path')
        RGitHook.stubs(:parse_path).with(:repo).returns(repo)
        RGitHook.expects(:install).with(repo,true).once.returns(:return_value)
        assert_equal RGitHook.new(:repo).install, :return_value
    end


    def test_class_call_editor
      repo = mock('grit_repo')
      repo.stubs(:path).returns('path')
      RGitHook.stubs(:parse_path).with(:repo).returns(repo)

      RGitHook.expects(:conf_file).returns(:file)
      RGitHook.expects(:system).with('vi',:file )
      RGitHook.call_editor(:repo)
    end

    def test_call_editor
      repo = mock('grit_repo')
      repo.stubs(:path).returns('path')
      RGitHook.stubs(:parse_path).with(:repo).returns(repo)
      
      RGitHook.expects(:call_editor).with(repo).once
      RGitHook.new(:repo).call_editor
    end
    
    HOOKS.each do |hook|
      hook_tests = <<-EOT
      def test_class_#{hook}
        assert RGitHook.public_methods.include?('#{hook}'), '#{hook} must be exists in RGitHook'
      end
      
      def test_class_#{hook}
        repo = mock('grit_repo')
        repo.stubs(:path).returns('path')
        RGitHook.stubs(:parse_path).with(:repo).returns(repo)
  
        assert RGitHook.new(:repo).public_methods.include?('#{hook}'), '#{hook} must be exists in a RGitHook instance'
      end
      EOT
      eval( hook_tests, binding, __FILE__, __LINE__-12)
    end
        

    def test_class_post_receive
      rgithook = mock()
      RGitHook.expects(:new).with(:dir).returns(rgithook)
      rgithook.expects(:post_receive).with(:a,:b,:c)
      RGitHook.post_receive(:dir,:a,:b,:c)
    end
              
    def test_install_template
      repo = mock('grit_repo')
      repo.stubs(:path).returns('path')
      RGitHook.stubs(:parse_path).with(:repo).returns(repo)

      File.expects(:dirname).returns('dirname')
            
      File.expects(:join).with('dirname','templates','from').returns(:from)
      File.expects(:join).with('path','hooks','to').returns(:to)
      
      FileUtils.expects(:install).with(:from,:to, :mode => 0666)
      
      RGitHook.send(:install_template,:repo, 'from','to',0666)
    end
    
    def test_install_template_with_defaults
      repo = mock('grit_repo')
      repo.stubs(:path).returns('path')
      RGitHook.stubs(:parse_path).with(:repo).returns(repo)

      File.expects(:dirname).returns('dirname')
            
      File.expects(:join).with('dirname','templates','from').returns(:from)
      File.expects(:join).with('path','hooks','from').returns(:to)
      
      FileUtils.expects(:install).with(:from,:to, :mode => 0600)
      
      RGitHook.send(:install_template,:repo, 'from')
    end

  end
end
