module RGitHook
  module Installation

    def self.included(base) #::nodoc::
      base.extend ClassMethods
    end

    # Install RGitHook in the given repo/path
    # if confirmation_needed it will ask to overwrite the existing hooks
    def install(confirmation_needed = true)
      self.class.install(@repo,confirmation_needed)
    end

    # Return true if rgithook is installed
    def installed?
      self.class.installed?(@repo)
    end

    module ClassMethods
      # Install RGitHook in the given repo/path
      # if confirmation_needed it will ask to overwrite the existing hooks
      def install(path_or_repo, verbose=true)
        repo = parse_path path_or_repo

        if verbose
          puts "Welcome to RGitHook.

          These will install rgithook for the next Git Repo
          /Users/guillermo/Sites/

          These will overwrite all the current hooks and
          create .git/hooks/rgithook.rb file.

          In that file you will define your hooks in ruby.
          ".gsub(/^        /,'')
          return -1 unless prompt('Continue?')
        end
        hooks_dir = File.join(repo.path,'hooks')
        FileUtils.mkdir hooks_dir unless File.exist? hooks_dir

        install_template(repo,'rgithook.rb')

        HOOKS.each do |hook_name|
          install_template(repo,'hook.rb',hook_name.tr('_','-'),0555)
        end

        if verbose
          puts "RGitHook Installed.
          Now you can:
          * Edit the hooks file by running
          rgithook --edit

          * Install the hooks file inside the repo. So all
          contributors can run hooks.
          mv .git/hooks/rgithook.rb ./config/rgithook.rb && \
          ln -s ./config/rgithook.rb

          or

          mv .git/hooks/rgithook.rb ./config/rgithook.rb && \
          ln -s ./.rgithook.rb

          * Fetch changes from origin
          rgithook --fetch
          ".gsub(/^        /,'')
        end
      end
      # Return true if rgithook is installed in the given repo
      def installed? (path_or_repo)
        File.file?(hooks_file(path_or_repo))
      end

      private
      def prompt(message)
        while true
          puts message+' [yn]'
          return 'yY'.include?($1) ? true : false if $stdin.gets.strip =~ /([yYnN])/
        end
      end

      def install_template(path_or_repo, from,to=nil,mode = 0600)
        to = from if to.nil?
        repo = parse_path(path_or_repo)

        from = File.join(PATH,'rgithook','templates',from)
        to   = File.join(repo.path,'hooks',to)
        FileUtils.install(from,to, :mode => mode)
      end
    end
  end
end