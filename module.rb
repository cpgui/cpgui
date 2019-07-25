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

    def console(command, args)
      exist = false
      @modules.each do |app_module|
        here_exist = app_module.console(command, args) if app_module.enabled?
        exist = true if here_exist
      end
      exist
    end

    def stop
      @modules.each(&:disable!)
    end

    def start
      @modules.each(&:enable!)
    end

    def auto_add
      send Rainbow('Adding modules...').yellow
      module_classes = ObjectSpace.each_object(Class).select do |c|
        c.included_modules.include? CPGUI::AppModule
      end
      add_classes(module_classes)
      send Rainbow('Successfully added modules!').green
    end

    attr_reader :modules
    def add_classes(classes)
      classes.each do |app_module_class|
        send Rainbow("Adding module #{app_module_class}...").yellow
        modules.push(app_module_class.new(self))
        send Rainbow("Successfully added module #{app_module_class}!").green
      end
    end

    def disable(app_module_class)
      modules.each do |app_module|
        next if app_module.class < app_module_class

        send "Disabling #{app_module}..."
        app_module.disable!
        send "Successfully disabled #{app_module}!"
      end
    end

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

    def enabled?
      @enabled
    end

    alias enable? enabled?

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

    def disabled?
      !@enabled
    end

    alias disable? disabled?

    def on_enable; end

    def on_disable; end

    def stop; end

    def console(_command, _args)
      false
    end

    def version
      'Alpha 0.0.1'
    end

    def prefix
      Rainbow('[' + self.class.to_s + '] ').yellow
    end

    def send(message)
      puts prefix + message
    end

    def error(message)
      puts prefix + Rainbow(message).red
    end

    def help
      ''
    end
  end
end
