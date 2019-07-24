# frozen_string_literal: true

# Main module for the cpgui
class MainModule
  include CPGUI::AppModule

  def initialize(module_manager)
    @module_manager = module_manager
  end

  def version
    'Alpha 0.0.1'
  end

  def prefix
    Rainbow('[MainModule] ').white
  end
end
