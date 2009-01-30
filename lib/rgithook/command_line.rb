require 'optparse'
require 'ostruct'
require 'fileutils'

module RGitHook
  class CommandLine
    
    # Parse command line options and execute
    def self.execute(args)
      options = parse_options(args)
      
      case options.command
      when :install,:fetch,:edit
        ret_val = RGitHook.new(options.path).send(options.command)
        exit 0
      when :version
        puts 'Version 3.0.0'
        exit 0
      end
      
    rescue Grit::InvalidGitRepositoryError
      puts "Invalid Git repository:\n#{@options.path}"
      exit 1
    end
    
    private
    def self.parse_options(args)
      options = OpenStruct.new
      options.command = :help
      options.path = Dir.pwd
      
      opts = OptionParser.new do |opts|
        opts.banner = "Usage #{File.basename $0} [options]"
        opts.on_head("-i","--install", "Install hooks on current dir") { options.command = :install }
        opts.on_head("-f","--fetch", "Fetch remote origin and run hooks") { options.command = :fetch }
        opts.on_head("-e","--edit", "Edit your hooks file with your EDITOR") { options.command = :edit }
        opts.on("-p","--path=[path]", "Run in another path insted of current path") { |path| options.path = path }
        opts.on_tail("--version", "Print current version and exit") {options.command = :version }
        opts.on_tail("-h","--help", "Print help message") 
      end
      opts.parse!(args)
      (puts opts and exit 0) if options.command == :help
      options
    end
      
  end
end
