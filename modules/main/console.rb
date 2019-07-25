# frozen_string_literal: true

# Main module for the cpgui
class MainModule
  def console(command, _args)
    case command
    when 'exit', 'quit', 'close', 'end', 'stop' then on_exit
    when 'info', 'information', 'cpgui' then on_info
    when 'main', 'main-module' then on_main
    when 'modules', 'module', 'mods', 'mod', 'h', 'help' then on_modules
    when 'r', 'rl', 'rel', 'reload', 'ref', 'refresh' then on_reload
    else
      return false
    end
    true
  end

  def on_main
    send Rainbow("main-#{version}").white
  end

  def on_info
    send Rainbow("cpgui-#{version}").white
  end

  def on_exit
    puts "\r\n"
    send Rainbow('Exiting application...').red
    exit
  end

  def modules
    module_classes = []
    @module_manager.modules.each do |app_module|
      if app_module.enabled?
        module_classes.push(Rainbow(app_module.class.name).green)
      else
        module_classes.push(Rainbow(app_module.class.name).red)
      end
    end
    module_classes
  end

  def on_modules
    module_classes = modules
    module_string = module_classes.join(Rainbow(', ').silver)
    output = Rainbow("#{@module_manager.modules.length} module(s): ").aqua
    send output + module_string
  end

  def on_reload
    send Rainbow('Reloading cpgui...').yellow
    @module_manager.stop
    @module_manager.start
    send Rainbow('Successfully reloaded cpgui!').green
  end
end
