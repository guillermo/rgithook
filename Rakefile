require 'config/requirements'
require 'config/hoe' # setup Hoe + all gem configuration

Dir['tasks/**/*.rake'].each { |rake| load rake }

desc 'Build a gem-spec'
task :build_gemspec do
  File.open("rgithook.gemspec","w").write(%x(rake debug_gem).split("\n")[1..-1].join("\n"))
end
