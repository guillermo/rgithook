module RGitHook
  # Interface from git-commands to RGitHook
  class Hook #::nodoc::
    class << self
      def execute
        puts "Executing #{File.basename($0)} hook"
        self.send File.basename($0).tr('-','_')
      end

      def post_receive
        packs = STDIN.read.split("\n")
        ret_vals = []

        rgithook = RGitHook.new repo_path

        packs.each do |pack|
          oldrev, newrev, ref = pack.split(' ')
          ret_vals << rgithook.post_receive(oldrev,newrev,ref).first[1].to_i
        end
        return ret_vals.max
      end

      def method_missing(method_name)
        RGitHook.new(repo_path).send(method_name)
        0
      rescue
        -1
      end

      private
      def repo_path
        if File.basename(File.expand_path(ENV['GIT_DIR']))  == '.git'
          repo_path = File.join(ENV['GIT_DIR'],'..')
        else
          repo_path = ENV['GIT_DIR']
        end
      end
    end
  end
end
