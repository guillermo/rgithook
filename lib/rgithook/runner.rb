module RGitHook
   class Runner

      attr_reader :binding

      def initialize(repo) #::nodoc::
         raise ArgumentError unless repo.is_a? ::Grit::Repo
         @_repo = repo
         @_hooks = {}
         @_bg_hooks = {}
         @options = Plugin.options_to_hash
      end

      # Define a hook that is executed when git-commands call these hook
      # These is the very most important part of rgithook. These are all
      # the hooks that you can run from git.
      #
      #   # GIT_DIR/hooks/rgithook.rb (edit by rgithook -e)
      #
      #   #These will make that you will never can commit anthing that brake the tests
      #   on :pre_commit do
      #     system(rake test)
      #   end
      #
      #   #These will send test results of the master branch when the repo is updated
      #   on :post_receive do |old_rev,new_rev,ref|
      #     if ref =~ /master$/
      #       %x(rake test | mail -s 'Updated #{ref}' guillermo@cientifico.net)
      #     end
      #   end
      #
      # Also you can make the hooks run in a separate process with background option
      #
      #   #These will run in background
      #   on :post_receive, :background => true do |old_rev,new_rev,ref|
      #     run_tests(repo) # These is a long runing operation
      #   end
      #
      # The abailable hooks within git docs are:
      #
      # * <em>on <b>:applypatch_msg</b> do |commit_msg_path| </em>- Check the commit log message
      #   taken by applypatch from an e-mail message.
      #   The hook should exit with non-zero status after issuing an
      #   appropriate message if it wants to stop the commit.  The hook is
      #   allowed to edit the commit message file.<br/>
      #   <em>commit_msg_path</em> - Is the file_path of the commit_message
      #
      # * <em>on <b>:commit_msg</b> do |commit_msg_path| </em>- Check the commit log message.
      #   Called by git-commit with one argument, the name of the file
      #   that has the commit message.  The hook should exit with non-zero
      #   status after issuing an appropriate message if it wants to stop the
      #   commit.  The hook is allowed to edit the commit message file.
      #   These hook have *params*:
      #   <em>commit_msg_path</em> - Is the file_path of the commit_message
      #
      # * <em>on <b>:post_commit</b> do </em>- Is called after a successful commit is made.
      #
      # * <em>on <b>:post_receive</b> do |old_rev,new_rev,ref| </em>- Is run after receive-pack has accepted a pack
      #   and the repository has been updated. <em>old_rev</em>/<em>new_rev</em> Is the string old/new sha1 commit id.
      #   <em>ref</em> is the string of the updated ref (<em>ref/head/master</em>).
      #   These is the perfect hook to put your code in a bare central repo.
      #
      #     # Send to the authors off the commits the results of their commits
      #     on :post_receive do |old_rev,new_rev,ref|
      #       if ref =~ /master$/
      #         emails = repo.commits_between(old_rev, new_rev).map{|c| c.author.email}.uniq
      #         test = %x(rake test)
      #         emails.each do |mail|
      #           IO.popen("mail -s 'Updated #{repo_name}' #{mail}",'w') {|mail| mail.write test}
      #         end
      #       end
      #     end
      #
      # * <em>on <b>:post_update</b> do</em> - Prepare a packed repository for use over
      #   dumb transports.
      #
      # * <em>on <b>:pre_apply_patch</b> do</em> - Verify what is about to be committed
      #   by applypatch from an e-mail message.
      #   The hook should return non zero after issuing an
      #   appropriate message if it wants to stop the commit.
      #
      # * <em>on <b>:pre_commit</b> do</em> - Verify what is about to be committed.
      #   Called by git-commit with no arguments.  The hook should
      #   return non-zero after issuing an appropriate message if
      #   it wants to stop the commit.
      #
      # * <em>on <b>:pre_rebase</b> do</em> - Run just before "git-rebase" starts doing
      #   its job, and can prevent the command from running by exiting with
      #   non-zero status.
      #
      # * <em>on <b>:prepare_commit_msg</b> do |commit_msg_path,commit_src|</em> - Prepare the commit log message.
      #   Called by git-commit with the name of the file that has the
      #   commit message, followed by the description of the commit
      #   message's source.  The hook's purpose is to edit the commit
      #   message file.  If the hook returns non-zero status,
      #   the commit is aborted.
      #
      # In case of an unrescue exception rgithook will show a warning with the error and return 255 to git.
      # In case of more than one block for the same hook, rgithook return to git the max value of all returns values of the same hook
      #
      #
      def on(hook, options = {}, &block)
         raise ArgumentError, "No block given for #{hook.to_s} in #{caller[0]}" unless block_given?
         if HOOKS.include? hook.to_s
            if options.delete(:background)
               @_bg_hooks[hook] ||= []
               @_bg_hooks[hook] << block
            else
               @_hooks[hook] ||= []
               @_hooks[hook] << block
            end
         else
            raise ArgumentError, "Not available hook #{hook.to_s} in #{caller[0]}"
         end
      end


      # Run arbitrary code in runner context
      def run(code,file=nil,line=nil)
         file,line = caller.first.split(':') unless file && line
         eval(code,binding,file,line.to_i)
      end

      def load(file)
         hooks = File.file?(file) && File.read(file) || ''
         eval(hooks, binding, file,0)
      end

      # Execute all the hooks defined in the configuration file
      # Return a two dimension array. The first element is the outputs of the foreground_hooks.
      # The second element is another array with the pids of the background_hooks
      #   fg_hook_val, bg_hook_val = @runner.run_hooks(hook_name)
      def run_hooks(hook_name, *args)
         [run_foreground_hooks(hook_name,*args),run_background_hooks(hook_name,*args)]
      end




      def run_foreground_hooks(hook_name,*args)
         ret_vals = []
         @_hooks[hook_name.to_sym] && @_hooks[hook_name.to_sym].each do |hook|
            ret_vals << hook.call(*args)
         end
         ret_vals
      end

      # Execute all the hooks in a new process
      # Return an array with the pids of each hook process
      def run_background_hooks(hook_name, *args)
         ret_vals = []
         @_bg_hooks[hook_name.to_sym] && @_bg_hooks[hook_name.to_sym].each do |hook|
            ret_vals << fork {hook.call(*args)}
         end
         ret_vals
      end

      def repo
         @_repo
      end

      # Hash with all the plugin options
      #   option[:PluginName][:option] => option_value
      #
      #   option[PluginClass.to_sym][:option_group][:option_name] => option_value
      #
      def options
         @options
      end

      # ::nodoc::
      def load_options(options_file)
         @options = YAML.load(File.read(options_file)) if File.file?(options_file)
         @options ||={}
      end
   end
end
