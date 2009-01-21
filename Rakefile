require 'rubygems'
begin
  require 'rake'
  require 'echoe'
rescue LoadError
  puts 'This script should only be accessed via the "rake" command.'
  puts 'Installation: gem install rake -y'
  exit
end


Echoe.new('rgithook') do |p|
  p.description    = "Ruby gem specify for git hooks."
  p.summary        = "You can deploy updated code, restart the web server, run the tests, email the diff, etc...\nYou can use a cron to pull or a githook to run when pushed to the repo."
  p.url            = "http://github.com/guillermo/rgithook2"
  p.author         = "Guillermo Álvarez"
  p.email          = "guillermo@cientifico.net"
  p.runtime_dependencies = ["mojombo-grit"]
  p.ignore_pattern = ["tmp/*", "script/*", "demo?/*", "pkg/*", "*.tmproj"]
  p.development_dependencies = ["mocha"]
end
 
