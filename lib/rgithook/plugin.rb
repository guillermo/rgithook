
module RGitHook
  
  class Plugin
    include ::RGitHook
    class Option #::nodoc::
      attr_reader :name,:description,:default,:type
      def initialize(name,description,default,type)
        @name, @description, @default, @type = name,description,default,type
      end      
    end
    
    class NoOptionError < Exception ; end

    class OptionGroup #::nodoc::
      # Todo: Make OptionGroup be an option of OptionGroup
      attr_reader :name,:description
      attr_reader :options
      def initialize(name,description)
        @name,@description = name,description
        @options = []
      end

      def option(name,desc,default,type)
        @options << Option.new(name,desc,default,type)
      end

      # Rertun a hash with default options
      #
      def options_to_hash
        group_options = {}
        @options.each do |option|
          group_options[option.name]= option.default
        end
        group_options
      end
    end

    # ::nodoc::
    # Return raw options
    def self.options
      @@options
    end
    
    # Initialize Plugin system by including each plugin modules to the Module
    # It also load the defaults from a yaml file.
    # You can change the default yaml file to load another file 
    def self.load!
      @@plugins ||=[]
      @@plugins.each do |plugin|
        if defined?(plugin::RunnerMethods)
          Runner.class_eval do
            include plugin::RunnerMethods
          end
        end
        
        if defined?(plugin::GritCommit)
          ::Grit::Commit.class_eval do
            include plugin::GritCommit
          end
        end
      end
    end


    # Return a hash with the default options
    def self.options_to_hash
      options = {}
      @@options.each do |plugin,plugin_options| 
        plugin_opts = {}
        plugin_options.each do |option|
          plugin_opts[option.name]=option.default.is_a?(OptionGroup) ? option.default.options_to_hash : option.default
        end
        options[plugin]=plugin_opts
      end
      options
    end

    private
    
    # Define a new option
    def self.option(name,desc,default,type)
      @@options[get_plugin_name(self)] << Option.new(name,desc,default,type)
    end

    def self.option_group(name,desc,&block)
      opt_group = OptionGroup.new(name,desc)
      yield opt_group
      option(name,desc,opt_group,OptionGroup)
    end

    def self.inherited(base)
      @@plugins ||=[]
      @@plugins << base
      @@options ||={}
      @@options[get_plugin_name(base)]=[]
    end
    
    private
    def self.get_plugin_name(kmod)
      kmod.to_s[/(.*\::)?(.*)/,2].to_sym
    end
  end
end

