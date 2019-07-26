# frozen_string_literal: true

require 'rainbow'
# The main class of the app
class CPGUI
  # This class handle the modules
  class ModuleManager
    def initialize(cpgui, modules)
      @cpgui = cpgui
      @modules = modules
      start
    end

    # Handle console command
    def console(command, args)
      exist = false
      @modules.each do |app_module|
        here_exist = app_module.console(command, args) if app_module.enabled?
        exist = true if here_exist
      end
      exist
    end

    # Stop the module manager
    def stop
      @modules.each(&:disable!)
    end

    # Start the module manager
    def start
      @modules.each(&:enable!)
    end

    # Add all modules which is a parent of the AppModule class
    def auto_add
      send Rainbow('Adding modules...').yellow
      module_classes = ObjectSpace.each_object(Class).select do |c|
        c.included_modules.include? CPGUI::AppModule
      end
      add_classes(module_classes)
      send Rainbow('Successfully added modules!').green
    end

    # Modules from the module manager
    attr_reader :modules

    # Add a single module to the module manager
    def add_classes(classes)
      classes.each do |app_module_class|
        send Rainbow("Adding module #{app_module_class}...").yellow
        modules.push(app_module_class.new(self))
        send Rainbow("Successfully added module #{app_module_class}!").green
      end
    end

    # Enable a module
    def enable(app_module_class)
      modules.each do |app_module|
        next unless app_module.class == app_module_class

        send Rainbow("Enabling #{app_module}...").yellow
        app_module.enable!
        send Rainbow("Successfully enabled #{app_module}!").green
      end
    end

    # Disable a module
    def disable(app_module_class)
      modules.each do |app_module|
        next unless app_module.class == app_module_class

        send Rainbow("Disabling #{app_module}...").yellow
        app_module.disable!
        send Rainbow("Successfully disabled #{app_module}!").green
      end
    end

    # The main class
    attr_reader :cpgui

    private

    def send(message)
      puts Rainbow('[ModuleManager] ').blue + message
    end
  end

  # Every module must be a child of this module!
  module AppModule
    def initialize(module_manager)
      @module_manager = module_manager
      @enabled = false
    end

    # Enable/Disable the module
    def enabled!(enable = true)
      if enable
        @enabled = true
        on_enable
      else
        @enabled = false
        on_disable
      end
    end

    alias enable! enabled!

    # Check if the module is enabled
    def enabled?
      @enabled
    end

    alias enable? enabled?

    # Disable/Enable the module
    def disabled!(disable = true)
      if disable
        @enabled = false
        on_disable
      else
        @enabled = true
        on_enable
      end
    end

    alias disable! disabled!

    # Check if module is disabled
    def disabled?
      !@enabled
    end

    alias disable? disabled?

    # Enable method.
    # Add this method to your module to do something if the module was enabled!
    def on_enable; end

    # Disable method.
    # Add this method to your module to do something if the module was disable!
    def on_disable; end

    # Handle console commands.
    # Add this method to your module to do something if a command was entered!
    def console(_command, _args)
      false
    end

    # Set the version of the module!
    def version
      'Alpha 0.0.1'
    end

    # Set the prefix of the module for the send and error method!
    def prefix
      Rainbow('[' + self.class.to_s + '] ').yellow
    end

    # Send the message with the prefix
    def send(message)
      puts prefix + message
    end

    # Send the method in red with the prefix
    def error(message)
      puts prefix + Rainbow(message).red
    end

    # Set the help method to get this via module <Module>
    def help
      ''
    end
  end
end
