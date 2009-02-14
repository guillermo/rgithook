module RGitHook
  module Base
    
    def self.included(base) #::nodoc::
      base.extend ClassMethods
    end
    
    
    # Initialize a new instance of rgithook in the given repo or path
    def initialize(repo_or_path)
       @repo = self.class.parse_path(repo_or_path)
       @runner    = Runner.new(@repo)
       @runner.load(hooks_file)
    end
    
    # Run some code in the runner binding
    def run(code,file=nil,line=nil)
       @runner.run(code,file,line)
    end
    
    #Extract the projects name
    def project_name
       if @repo.bare
          File.basename(@repo.path) =~ /(.*).git/
          $1 || @repo.bare
       else
          File.basename(@repo.working_dir)
       end
    end

    # Returns the path of the current repo
    def path
       @repo.path
    end

    # Returns the path of the working dir or nil if it is a bare repo
    def working_path
       @repo.working_dir
    end

    # Returns true on bare repo.
    def bare?
       @repo.bare
    end
    
    def hooks_file
       self.class.hooks_file(@repo)
    end
        
    private
    
    module ClassMethods
      def hooks_file(repo_or_path)
         File.join(parse_path(repo_or_path).path,'hooks','rgithook.rb')
      end

      def parse_path(path)
         case path
         when ::Grit::Repo
            path
         when String
            ::Grit::Repo.new(path)
         end
      rescue Grit::InvalidGitRepositoryError
         raise ArgumentError, 'path is not a valid git repo'
      end
    end
  end
end
