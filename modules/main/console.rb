# frozen_string_literal: true

# Main module for the cpgui
class MainModule
  def console(command, _args)
    case command
    when 'exit', 'quit', 'close', 'end', 'stop' then on_exit
    when 'info', 'information', 'cpgui' then puts "cpgui-#{CPGUI.version}"
    when 'main', 'main-module' then puts "main-#{MainModule.version}"
    when 'modules', 'module', 'mods', 'mod', 'h', 'help' then on_modules
    when 'r','rl','rel','reload','ref','refresh' then on_reload
    else
      false
    end
    true
  end

  def on_exit
    puts "\r\nExiting application..."
    exit
  end

  def on_modules; end
  def on_reload
    puts 'Reloading cpgui...'
    @module_manager.stop
    @module_manager.run
  end
end
