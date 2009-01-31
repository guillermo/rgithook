
class Custom < RGitHook::Plugin

   option :post_code, 'Post Code to execute ', '', String
   option :pre_code , 'Post code to execute', '', String

   module RunnerMethods

      def pre_code
         eval(options[:Custom][:pre_code],binding,'custom_pre_commit_code',0)
      end

      def post_code
         eval(options[:Custom][:pre_code],binding,'custom_post_commit_code',0)
      end
   end
end

