# frozen_string_literal: true

puts 'Loading app file...'
# The main class of the app
class CPGUI
  def initialize(bot_modules)
    @console_manager = CPGUI::ConsoleManager.new(self)
    @module_manager = CPGUI::ModuleManager.new(self, bot_modules)
  end

  def run
    @console_manager.run
  end

  def self.version
    'Alpha 0.0.1'
  end

  attr_reader :console_manager
  attr_reader :module_manager
end
puts 'Successfully loaded app file!'
