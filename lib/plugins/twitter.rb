

class Twitter < RGitHook::Plugin
  
  option :user, 'Username', nil, String
  option :password, 'Password', nil, String
  
  module RunnerMethods
    def twitter(msg)
      %(curl http://twitter.com -u #{options[:Twitter][:user]} -)
    end
  end
end
