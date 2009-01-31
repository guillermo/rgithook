require File.dirname(__FILE__)+'/../test_helper'

module RGitHook

  class RGitHookTest < Test::Unit::TestCase
    def setup
      @runner = mock('runner')
      @runner.stubs(:load_options)
      @runner.stubs(:binding)
      @runner.stubs(:load)
      @repo = mock('grit_repo')
      @repo.stubs(:path).returns('path')
      Runner.stubs(:new).returns(@runner)
    end

    def test_run
      @runner.expects(:run).with('code',nil,nil).returns(:done)
      assert_equal :done, create_rgithook_instance.run('code')
    end
    
    
    def test_class_install
        repo = mock('grit_repo')
        repo.stubs(:path).returns('path')
        ::Grit::Repo.stubs(:new).with(:repo).returns(repo)  
        
        FileUtils.stubs(:mkdir).with('path/hooks')
        File.expects(:'exist?').with('path/hooks')
        RGitHook.expects(:install_template).at_least(4)
        RGitHook.expects(:parse_path).with(:repo).returns(repo)
        RGitHook.install(:repo,false)
    end




    def test_install
        RGitHook.expects(:install).with(@repo,true).once.returns(:return_value)
        assert_equal create_rgithook_instance.install, :return_value
    end


    def test_class_call_editor
      RGitHook.stubs(:parse_path).with(:repo).returns(mock_repo)
      RGitHook.expects(:conf_file).returns(:file)
      RGitHook.expects(:system).with('vi',:file )
      RGitHook.call_editor(:repo)
    end


    # # Open the editor with the config file
    # def call_editor
    #   self.class.call_editor(@repo)
    # end

    def test_call_editor   
      rgithook = create_rgithook_instance
      RGitHook.expects(:call_editor).with(@repo).once
      rgithook.call_editor   
    end
    
    HOOKS.each do |hook|
      hook_tests = <<-EOT
      def test_class_#{hook}
        assert RGitHook.public_methods.include?('#{hook}'), '#{hook} must be exists in RGitHook'
      end
      
      def test_#{hook}
        @rgithook = create_rgithook_instance
        assert @rgithook.public_methods.include?('#{hook}'), '#{hook} must be exists in a RGitHook instance'
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
      File.expects(:join).with(PATH,'rgithook','templates','from').returns(:from)
      File.expects(:join).with('path','hooks','to').returns(:to)      
      FileUtils.expects(:install).with(:from,:to, :mode => 0666)
      
      RGitHook.send(:install_template,:repo, 'from','to',0666)
    end
    
    def test_install_template_with_defaults
      repo = mock('grit_repo')
      repo.stubs(:path).returns('path')
      RGitHook.stubs(:parse_path).with(:repo).returns(repo)

      File.expects(:join).with(PATH,'rgithook','templates','from').returns(:from)
      File.expects(:join).with('path','hooks','from').returns(:to)
      
      FileUtils.expects(:install).with(:from,:to, :mode => 0600)
      
      RGitHook.send(:install_template,:repo, 'from')
    end


    # def initialize(repo_or_path)
    #   @repo = self.class.parse_path(repo_or_path)
    #   Plugin.load!      
    #   @runner    = Runner.new(@repo)
    #   @runner.load_options(plugin_conf_file)
    #   @runner.load(hooks_file)
    # end

    def test_new
      Plugin.expects(:load!)
      RGitHook.expects(:parse_path).with(@repo).returns(@repo)
      Runner.expects(:new).with(@repo).returns(@runner)
      @runner.expects(:load_options).with('plugin_conf_file')
      @runner.expects(:load).with('hooks_file')
      RGitHook.any_instance.expects(:plugin_conf_file).returns('plugin_conf_file')
      RGitHook.any_instance.expects(:hooks_file).returns('hooks_file')
      
      
      RGitHook.new(@repo)
    end
    
    
    def test_save_plugin_options
      RGitHook.stubs(:parse_path).with(@repo).returns(@repo)
      
      options = {:option => 1}
      @repo.stubs(:path).returns('path')
      @runner.expects(:options).returns(options)
      file = mock('IO')
      file.expects(:write).with(options.to_yaml)
      File.expects(:open).with('path/hooks/rgithook.yaml','w').yields(file)
      
      @rgithook = RGitHook.new(@repo)
      @rgithook.save_plugin_options
    end
    

    
    
  end
end
