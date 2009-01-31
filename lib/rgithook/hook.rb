

module RGitHook
   # Interface from git-commands to RGitHook
   class Hook #::nodoc::

      def self.execute
         puts "Executing #{File.basename($0)} hook"
         self.send File.basename($0).tr('-','_')
      end

      def self.post_receive
         packs = STDIN.read.split("\n")

         ret_vals = []

         rgithook = RGitHook.new repo_path

         packs.each do |pack|
            oldrev, newrev, ref = pack.split(' ')
            ret_vals << rgithook.post_receive(oldrev,newrev,ref)
         end
         return ret_vals.max
      end

      private
      def self.repo_path
         if File.basename(File.expand_path(ENV['GIT_DIR']))  == '.git'
            repo_path = File.join(ENV['GIT_DIR'],'..')
         else
            repo_path = ENV['GIT_DIR']
         end
      end
   end
end

