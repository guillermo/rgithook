

class Test::Unit::TestCase
  def mock_repo
    repo = mock('grit_repo')
    repo.stubs(:'is_a?').with(::Grit::Repo).returns(true)
    repo.stubs(:path).returns('path')
    repo
  end

  def create_rgithook_instance
    # This is not really a rgithook_instance ;-P
    ::RGitHook::Plugin.stubs(:load!)
    ::RGitHook::RGitHook.stubs(:parse_path).with(@repo).returns(@repo)
    ::RGitHook::Runner.stubs(:new).with(@repo).returns(@runner)
    @runner.stubs(:load_options).with('plugin_conf_file')
    @runner.stubs(:load).with('hooks_file')
    ::RGitHook::RGitHook.any_instance.stubs(:plugin_conf_file).returns('plugin_conf_file')
    ::RGitHook::RGitHook.any_instance.stubs(:hooks_file).returns('hooks_file')
    ::RGitHook::RGitHook.new(@repo)
  end

  def in_temp_dir(&block)
    old_dir = Dir.pwd
    raise LocalJumpError, 'no block given' unless block_given?

    tmpdir = File.expand_path(File.join(Dir.tmpdir,'rgithook-'+Time.now.usec.to_s+rand.to_s[2..-1]))
    FileUtils.mkdir_p(tmpdir)
    Dir.chdir tmpdir
    ret_val = yield tmpdir
    Dir.chdir old_dir
    FileUtils.remove_dir(tmpdir)
    ret_val
  end

  def in_sample_repo
    in_temp_dir do |temp_file|
      %x(unzip #{fixture_path('sample_repo.zip')})
      yield ::Grit::Repo.new(temp_file)
    end
  end


  def with_sample_rgithook
    in_sample_repo do |repo|
      @rgithook = ::RGitHook::RGitHook.new(repo)
      yield @rgithook
    end
  end

  # Execute something in the runner
  # @rgithook must exists
  def in_runner(code,file=nil,line=nil)
    file,line = caller.first.split(":") unless file && line
    if @rgithook
      @rgithook.run(code,file,line)
    else
      with_sample_rgithook do
        RGitHook::Plugin.load!
        @rgithook.run(code,file,line)
      end
    end
  end
  
  private
  def fixture_path(fixture_name)
    file = File.join(::RGitHook::PATH,'..','test','fixtures',fixture_name)
    file if File.file?(file) or raise "Not found fixture in #{file}"
  end
end
