# frozen_string_literal: true

# Main module for the cpgui
class MainModule
  include CPGUI::AppModule

  def on_enable
    send Rainbow('Enabling main module...').yellow
    send Rainbow('Successfully enabled main module!').green
  end

  def version
    'Alpha 0.0.1'
  end

  def prefix
    Rainbow('[MainModule] ').white
  end
end
