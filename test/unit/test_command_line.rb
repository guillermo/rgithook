require File.dirname(__FILE__)+'/../test_helper'

module RGitHook
  class CommandLineTest < TestCase
    def setup
      @repo = mock()
      @rgithook = mock()
      ::Grit::Repo.stubs(:new).returns(@repo)
      Dir.stubs(:pwd).returns('pwd')
    end

    def test_install
      RGitHook.expects(:new).with('pwd').returns(@rgithook)
      @rgithook.expects(:install)
      CommandLine.expects(:exit).with(0)
      CommandLine.execute(['--install'])
    end

    def test_edit
      RGitHook.expects(:new).with('pwd').returns(@rgithook)
      @rgithook.expects(:edit)
      CommandLine.expects(:exit).with(0)
      CommandLine.execute(['--edit'])
    end

    def test_fetch
      RGitHook.expects(:new).with('pwd').returns(@rgithook)
      @rgithook.expects(:fetch)
      CommandLine.expects(:exit).with(0)
      CommandLine.execute(['--fetch'])
    end

    # def test_install_in_bare_repo
    #   in_temp_bare_repo do |repo|
    #     assert system(rgithook_command_path("--install --path=#{repo.path}"))
    #     check_files(repo)
    #   end
    # end


    def hide
      " 2>&1 > /dev/null"
    end

    def check_files(repo)
      path = File.join(repo.path,'hooks')
      file = File.join(path,'rgithook.rb')
      assert File.exist?(file)
      assert_equal 0600, (File.stat(file).mode & 0777)

      HOOKS.each do |hook_name|
        file = File.join(path,hook_name.tr('_','-'))
        assert File.exist?(file)
        assert_equal 0555, (File.stat(file).mode & 0777)
      end
    end
  end
end
