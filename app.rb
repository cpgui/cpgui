# frozen_string_literal: true

puts Rainbow('[CPGUI] ').white + Rainbow('Loading app file...').yellow
# The main class of the app
class CPGUI
  def initialize(bot_modules)
    @console_manager = CPGUI::ConsoleManager.new(self)
    @module_manager = CPGUI::ModuleManager.new(self, bot_modules)
    @module_manager.auto_add
  end

  def run
    @console_manager.run
  end

  def version
    'Alpha 0.0.1'
  end

  attr_reader :console_manager
  attr_reader :module_manager
end
puts Rainbow('[CPGUI] ').white + Rainbow('Successfully loaded app file!').green
