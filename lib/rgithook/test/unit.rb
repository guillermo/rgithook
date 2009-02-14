module RGitHook
  class TestCase < Test::Unit::TestCase
    
    # Default test to make test::unit ignore tests_classes withot tests
    def default_test
    end
    
    # returns a mocked grit_repo able to run with rgithook
    def mock_repo
      repo = mock('grit_repo')
      repo.stubs(:'is_a?').with(::Grit::Repo).returns(true)
      repo.stubs(:path).returns('path')
      repo
    end

    # Returns initialized rgithook instance with a mocked repo.
    def create_rgithook_instance
      # This is not really a rgithook_instance ;-P
      ::RGitHook::RGitHook.stubs(:parse_path).with(@repo).returns(@repo)
      ::RGitHook::Runner.stubs(:new).with(@repo).returns(@runner)
      @runner.stubs(:load).with('hooks_file')
      ::RGitHook::RGitHook.any_instance.stubs(:hooks_file).returns('hooks_file')
      ::RGitHook::RGitHook.new(@repo)
    end

    # Runs block in a temp dir
    def in_temp_dir(&block)
      old_dir,ret_val = Dir.pwd, nil
      # Don't use mktemp from system since osx and linux mktemp are diferentes.
      tmpdir = File.expand_path(File.join(Dir.tmpdir,'rgithook-'+Time.now.usec.to_s+rand.to_s[2..-1]))
      
      FileUtils.mkdir_p(tmpdir)
      Dir.chdir tmpdir
      ret_val = yield tmpdir
    ensure
      Dir.chdir old_dir
      FileUtils.remove_dir(tmpdir)
      ret_val
    end

    # Runs block in a temp repo. 
    # The block receive the new Grit::Repo as an argument
    # By default, the repo is a non-bare repo.
    def in_sample_repo(options = {},&block)
      in_temp_dir do |temp_file|
        %x(unzip #{fixture_path('sample_repo.zip')} #{without_output})
        yield ::Grit::Repo.new(temp_file)
      end
    end


    # Runs block in a sample repo and yields rgithook
    def with_sample_new_rgithook(&block)
      in_sample_repo do |repo|
        @rgithook = ::RGitHook::RGitHook.new(repo)
        yield @rgithook
      end
    end
    
    # Runs block in a sample repo with rgithook installed
    def with_sample_rgithook(&block)
      with_sample_new_rgithook do 
        @rgithook.install(false)
        yield @rgithook
      end
    end

    private
    def fixture_path(fixture_name)
      file = File.join(::RGitHook::PATH,'..','test','fixtures',fixture_name)
      file if File.file?(file) or raise "Not found fixture in #{file}"
    end
    
    def without_output
      "> /dev/null 2>&1"
    end
  end
end