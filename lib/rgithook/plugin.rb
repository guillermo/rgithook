
module RGitHook
  module Plugin
    def self.included(base)
      ::RGitHook::Runner.class_eval do
        include base
      end
    end
  end
end
