module RGitHook 
  HOOKS = %w(applypatch_msg
  commit_msg
  post_commit
  post_receive
  post_update
  pre_applypatch
  pre_commit
  pre_rebase
  prepare_commit_msg
  update)

  class RGitHook    
    attr_reader :repo

    # Install RGitHook in the given repo/path
    # if confirmation_needed it will ask to overwrite the existing hooks
    def self.install(path_or_repo, verbose=true)
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

    # Install RGitHook in the given repo/path
    # if confirmation_needed it will ask to overwrite the existing hooks
    def install(confirmation_needed = true)
      self.class.install(@repo,confirmation_needed)
    end

    # TODO: Checker about installation
    # def self.installed_in? (path_or_repo)
    #   raise NoMethodError, 'Unimplemented'
    # end      
    # 
    # def installed?
    #   self.class.installed_in? (@repo)
    # end

    # Open the editor with the config file
    def self.call_editor(path_or_repo)
      repo = parse_path path_or_repo
      system(ENV['EDITOR'] || 'vi',conf_file)
    end

    # Open the editor with the config file
    def call_editor
      self.class.call_editor(@repo)
    end

    # Get the config file of the current repo or path
    def self.conf_file(path_or_repo)
      repo = parse_path path_or_repo
      File.join(repo.path,'hooks','rgithook.rb')
    end

    # Get the config file of the current repo or path
    def conf_file
      self.class.conf_file(@repo)
    end

    #TODO: Make a reload method, to reload conf_file and hooks_file

    HOOKS.each do |hook_name|
      start_line = __LINE__
      hook_methods =<<-EOHM
      def self.#{hook_name}(path_or_repo,*args)
        RGitHook.new(path_or_repo).#{hook_name}(*args)
      end
      
      def #{hook_name}(*args)
        @runner.run_hooks(:#{hook_name.to_sym},*args)
      end
      
      EOHM
      eval(hook_methods,binding,__FILE__,start_line+2)
    end


    # Call post_receive hooks
    def self.post_receive(path_or_repo,oldrev,newrev,ref)
      r = RGitHook.new(path_or_repo)
      r.post_receive(oldrev,newrev,ref)
    end

    # Call post_receive hooks      
    def post_receive(oldrev,newrev,ref)
      @runner.run_hooks(:post_receive,oldrev,newrev,ref)
    end

    def save_plugin_options
      File.open(plugin_conf_file,'w') {|f| f.write @runner.options.to_yaml }
    end
    
    # Run some code in the runner binding
    def run(code,file=nil,line=nil)
      @runner.run(code,file,line)
    end
      

    private

    def self.prompt(message)
      while true
        puts message+' [yn]'
        return 'yY'.include?($1) ? true : false if $stdin.gets.strip =~ /([yYnN])/
      end
    end


    def self.parse_path(path)
      case path 
      when ::Grit::Repo
        path
      when String
        ::Grit::Repo.new(path)
      end
    rescue Grit::InvalidGitRepositoryError
      raise ArgumentError, 'path is not a valid git repo'
    end


    # Contains the current runner with the hooks
    attr_reader :runner

    
    def self.install_template(path_or_repo, from,to=nil,mode = 0600)
      to = from if to.nil?
      repo = parse_path(path_or_repo)

      from = File.join(PATH,'rgithook','templates',from)
      to   = File.join(repo.path,'hooks',to)
      FileUtils.install(from,to, :mode => mode)
    end

    # Initialize a new instance of rgithook in the given repo or path
    def initialize(repo_or_path)
      @repo = self.class.parse_path(repo_or_path)
      Plugin.load!      
      @runner    = Runner.new(@repo)
      @runner.load_options(plugin_conf_file)
      @runner.load(hooks_file)
    end
    
    def hooks_file
      File.join(@repo.path, 'hooks', 'rgithook.rb')
    end
    
    def plugin_conf_file
      File.join(@repo.path,'hooks','rgithook.yaml')
    end
    
  end
end