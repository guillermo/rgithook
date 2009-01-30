

module RGitHook
  class Rake < Plugin
    
    module RunnerMethods
      def rake(task,*options)
        %x(rake #{task})
      end
    end
  end
end

  