require 'fileutils'
require 'tempfile'


class Temp < RGitHook::Plugin

   module RunnerMethods

      # Run tests in a temp dir.
      # One argument is passed repo, that is a instance of the new Grit.repo
      # You can use repo.path to see where is it.
      # It receives a block with repo passed.
      def in_temp_commit(commit,&block)
         raise ArgumentError unless block_given?
         in_temp_dir do |temp_dir|
            repo_dir = File.join(temp_dir,commit.to_s)
            
            old_dir = Dir.pwd
            %x(git clone #{repo.path} #{repo_dir})
            Dir.chdir repo_dir
            
            %x(git checkout #{commit.is_a?(::Grit::Commit) ? commit.sha : commit})
            yield ::Grit::Repo.new(repo_dir)
            Dir.chdir old_dir
         end
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
   end
end
