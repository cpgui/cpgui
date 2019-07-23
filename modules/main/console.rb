# frozen_string_literal: true

# Main module for the cpgui
class MainModule
  def console(command, _args)
    case command
    when 'exit', 'quit', 'close', 'end', 'stop' then on_exit
    when 'info', 'information', 'cpgui' then puts Rainbow('[MainModule] ').white + Rainbow("cpgui-#{CPGUI.version}").white
    when 'main', 'main-module' then puts Rainbow('[MainModule] ').white + Rainbow("main-#{MainModule.version}").white
    when 'modules', 'module', 'mods', 'mod', 'h', 'help' then on_modules
    when 'r', 'rl', 'rel', 'reload', 'ref', 'refresh' then on_reload
    else
      false
    end
    true
  end

  def on_exit
    puts "\r\n" + Rainbow('[MainModule] ').white + Rainbow('Exiting application...').red
    exit
  end

  def on_modules
    module_classes = []
    @module_manager.modules.each do |app_module|
      module_classes.push(app_module.class.name)
    end
    module_string = moduleClasses.join(', ')
    output = "All modules: #{@module_manager.modules.length}: " + module_string
    puts Rainbow('[MainModule] ').white + Rainbow(output).aqua
  end
  def on_reload
    puts Rainbow('[MainModule] ').white + Rainbow('Reloading cpgui...').yellow
    @module_manager.stop
    @module_manager.run
    puts Rainbow('[MainModule] ').white + Rainbow('Successfully reloaded cpgui!').green
  end
end
