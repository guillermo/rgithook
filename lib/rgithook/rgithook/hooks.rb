module RGitHook
  module Hooks

    def self.included(base) #::nodoc::
      base.extend ClassMethods
    end
    
    ::RGitHook::HOOKS.each do |hook_name|
      eval(<<-EOHM,binding,__FILE__,__LINE__)
        def #{hook_name}(*args)
          @runner.run_hooks(:#{hook_name.to_sym},*args)
        end
      EOHM
    end


    # Call post_receive hooks
    def post_receive(oldrev,newrev,ref)
       @runner.run_hooks(:post_receive,oldrev,newrev,ref)
    end
    
    
    module ClassMethods
      ::RGitHook::HOOKS.each do |hook_name|
        eval(<<-EOHM,binding,__FILE__,__LINE__)
          def #{hook_name}(path_or_repo,*args)
            RGitHook.new(path_or_repo).#{hook_name}(*args)
          end
        EOHM
      end

      # Call post_receive hooks
      def post_receive(path_or_repo,oldrev,newrev,ref)
         r = RGitHook.new(path_or_repo)
         r.post_receive(oldrev,newrev,ref)
      end
    end
  end
end
