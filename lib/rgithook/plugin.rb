
module RGitHook
  CONF_FILE='rgithook.yaml'  
  
  class Plugin
    include ::RGitHook
    class Option #::nodoc::
      attr_reader :name,:description,:default,:type
      attr_accessor :value
      def initialize(name,description,default,type)
        @name, @description, @default, @type = name,description,default,type
        reset_defaults!
      end
      
      def reset_defaults!
        if default.is_a?(OptionGroup)
          @value = @default
          @value.reset_defaults!
        else
          @value = @default
        end
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

      def load_values_from_hash(new_values)

      end

      def option(name,desc,default,type)
        @options << Option.new(name,desc,default,type)
      end

      def [](selected_option)
        option = @options.select{|opts| opts.name == selected_option}.first
        raise NoOptionError unless option
        option.value
      end

      def []=(selected_option,new_value)
        option = @options.select{|opts| opts.name == selected_option}.first
        raise NoOptionError unless option
        option.value = new_value
      end

      def serialize_values
        group_options = {}
        @options.each do |option|
          group_options[option.name]= option.value
        end
        group_options
      end
      
      def deserialize_values(values_hash)
        values_hash.each do |option,value|
          opt = @options.select{|opts| opts.name == option}.first
          opt && opt.value= value
        end
      end
      
      def reset_defaults!
        @options.each do |option|
          option.value = option.default
        end
      end
    end

    
    # Reset all the values to it's default value
    # You can reset all plugins or just one
    #  
    #   Plugin.reset_defaults!
    #   SamplePlugin.reset_defaults!
    def self.reset_defaults!
      if self == Plugin
        @@options.each do |plugin,plugin_options|
          plugin_options.each {|plg_opt| plg_opt.reset_defaults!}
        end
      else
        @@options[get_plugin_name(self)].each {|plg_opt| plg_opt.reset_defaults!}
      end
    end

    def self.options #::nodoc::
      self == Plugin ? @@options : @@options[get_plugin_name(self)]
    end

    # Initialize Plugin system by including each plugin modules to the Module
    # It also load the defaults from a yaml file.
    # You can change the default yaml file to load another file 
    def self.load! (yaml_file = nil)
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
      
      deserialize_values(File.read(yaml_file|| CONF_FILE))
    end

    # Save the current values of all plugins to the config file
    # You can save to another file.
    def self.save!(yaml_file = nil)
      File.new(yaml_file||CONF_FILE,'w').write(serialize_values)
    end

    # Geter for a option value for a specific plugin
    #   SamplePlugin[:option]  => option_value
    #
    # It can be used with option_groups by asking for a :group_name
    #   SamplePlugin[:option_group][:option_name]
    # 
    # It will raise NoMethodError is called from Plugin
    #   Plugin[:option] =>  # raise NoMethodError
    #
    # It will raise NoOptionError if asked for some no_defined  plugin option
    #   SamplePlugin[:unknow_option]  # raise NoOptionError
    def self.[](selected_option)
      raise NoMethodError if self == Plugin
      option = @@options[get_plugin_name(self)].select{|opts| opts.name == selected_option}.first
      raise NoOptionError unless option
      option.value
    end
    
    # Setter for a option value for a specific plugin
    #   SamplePlugin[:option] = 4
    #
    # It can be used with option_groups by asking for a :group_name
    #   SamplePlugin[:option_group][:option_name] = 'sample_string'
    # 
    # It will raise NoMethodError is called from Plugin
    #   Plugin[:option] = 4 =>  # raise NoMethodError
    def self.[]=(selected_option,new_value)
      raise NoMethodError if self == Plugin
      option = @@options[get_plugin_name(self)].select{|opts| opts.name == selected_option}.first
      raise NoOptionError unless option
      @@options[get_plugin_name(self)].select{|opts| opts.name == selected_option}.first.value = new_value
    end

    private


    def self.serialize_values
      options = {}
      @@options.each do |plugin,plugin_options| 
        plugin_opts = {}
        plugin_options.each do |option|
          plugin_opts[option.name]=option.value.is_a?(OptionGroup) ? option.value.serialize_values : option.value
        end
        options[plugin]=plugin_opts
      end
      options.to_yaml
    end

    def self.deserialize_values(yaml_string)
      plugins = YAML.load(yaml_string)
      load_values_from_hash(plugins)
    end
    
    def self.load_values_from_hash(plugins_values)
      plugins_values.each do |plugin,plugin_values|
        plugin_values.each do |key,val|
          return unless @@options[plugin]
          return unless option = @@options[plugin].select{|o| o.name == key}.first
          if option.value.is_a? OptionGroup
            option.value.deserialize_values(val)
          else
            option.value = val if option
          end
        end
      end
    end


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
    
    def self.get_plugin_name(kmod)
      kmod.to_s[/(.*\::)?(.*)/,2].to_sym
    end
  end
end

