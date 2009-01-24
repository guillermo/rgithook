require 'dbm'

class CommitDB < RGitHook::Plugin
  
  module GritCommit
    # Read properties from a commit
    def properties
      db = get_commit_database
      @properties ||= (v = db[self.sha] and Marshal.load v)
    ensure
      db.close
    end

    # Write properties for a commit
    def properties=(data)
      @properties = data
      db = get_commit_database
      db[self.sha] = Marshal.dump data
    ensure
      db.close
    end

    private
    def get_commit_database
      ::DBM.new(File.join(@repo.path,'hooks','commitsdb'))
    end
  end
end
