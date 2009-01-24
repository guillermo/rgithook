require 'fileutils'
require 'tempfile'

class Temp < RGitHook::Plugin

  module RunnerMethods

    # Run tests in a temp dir.
    # One argument is passed repo, that is a instance of the new Grit.repo
    # You can use repo.path to see where is it
    def in_temp_commit(commit,&block)
      raise ArgumentError unless block_given?
      in_temp_dir do |temp_dir|
        repo_dir = File.join(temp_dir,commit.to_s)
        %x(git clone --depth 1 #{@repo.path} #{repo_dir})
        yield Repo.new(repo_dir)
      end
    end

    def in_temp_dir(&block)
      raise LocalJumpError, 'no block given' unless block_given?

      tmpdir = File.join(Dir.tmpdir,'rgithook',Time.now.usec.to_s+rand.to_s[2..-1])
      FileUtils.mkdir_p(tmpdir)

      ret_val = yield tmpdir

      FileUtils.remove_dir(tmpdir)
      ret_val
    end
  end
end
