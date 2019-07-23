# frozen_string_literal: true

puts 'Loading module file...'
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

    attr_reader :modules
  end
  # Every module must be a child of this module!
  module AppModule
    def initialize; end

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
puts 'Successfully loaded the module file!'
