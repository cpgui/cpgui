# frozen_string_literal: true
require 'rainbow'
puts Rainbow('[ModuleManager] ').blue + Rainbow('Loading module file...').yellow
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
      @modules.each(&:stop)
    end

    def start
      @modules.each(&:start)
    end

    def auto_add
      puts Rainbow('[ModuleManager] ').blue + Rainbow('Adding modules...').yellow
      module_classes = ObjectSpace.each_object(Class).select do |c|
        c.included_modules.include? CPGUI::AppModule
      end
      module_classes.each do |app_module_class|
        modules.push(app_module_class.new(self))
      end
      puts Rainbow('[ModuleManager] ').blue + Rainbow('Successfully added modules!').green
    end

    attr_reader :modules
  end

  # Every module must be a child of this module!
  module AppModule
    def initialize(module_manager); end

    def start; end

    def stop; end

    def console(_command, _args)
      false
    end

    def self.version
      'Alpha 0.0.1'
    end
  end
end
puts Rainbow('[ModuleManager] ').blue + Rainbow('Successfully loaded the module file!').green
