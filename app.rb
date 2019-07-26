# frozen_string_literal: true

# The main class of the app
class CPGUI
  def initialize(bot_modules)
    @console_manager = CPGUI::ConsoleManager.new(self)
    @module_manager = CPGUI::ModuleManager.new(self, bot_modules)
    @module_manager.auto_add
  end

  # Run the cpgui
  def run
    @module_manager.start
    @console_manager.run
  end

  # Stop the cpgui
  def stop
    @module_manager.stop
    @console_manager.stop
  end

  # The version of the cpgui
  def version
    'Alpha 0.0.1'
  end

  attr_reader :console_manager
  attr_reader :module_manager
end