module RGitHook
  module Editor

    def self.included(base)#::nodoc::
      base.extend ClassMethods
    end
    

    # Open the editor with the config file
    def call_editor
      self.class.call_editor(@repo)
    end
    
    module ClassMethods
      # Open the editor with the config file
      def call_editor(path_or_repo)
        repo = parse_path path_or_repo
        system(ENV['EDITOR'] || 'vi',hooks_file)
      end
    end
  end
end
