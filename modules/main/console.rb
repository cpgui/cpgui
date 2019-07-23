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
      false
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

  def on_modules
    module_classes = []
    @module_manager.modules.each do |app_module|
      module_classes.push(app_module.class.name)
    end
    module_string = module_classes.join(', ')
    output = "#{@module_manager.modules.length} modules: " + module_string
    send Rainbow(output).aqua
  end
  def on_reload
    send Rainbow('Reloading cpgui...').yellow
    @module_manager.stop
    @module_manager.run
    send Rainbow('Successfully reloaded cpgui!').green
  end
end
