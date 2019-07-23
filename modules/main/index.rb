# frozen_string_literal: true

# Main module for the cpgui
class MainModule
  include CPGUI::AppModule
  def initialize(module_manager)
    @module_manager = module_manager
  end

  def self.version
    'Alpha 0.0.1'
  end

end
