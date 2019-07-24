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
        exist = true if app_module.console(command, args)
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

    def enabled!(enable)
      @enabled = enable
    end

    def enabled?
      @enabled
    end

    def disabled!(disable)
      @enabled = !disable
    end

    def disabled?
      !@enabled
    end

    def enable!
      @enabled = true
    end

    def disable!
      @enabled = false
    end

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

    def help
      ''
    end
  end
end
