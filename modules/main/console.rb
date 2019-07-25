# frozen_string_literal: true
require 'json'
# Main module for the cpgui
class MainModule
  def console(command, args)
    return true if module_console(command, args)

    case command
    when 'exit', 'quit', 'close', 'end', 'stop' then on_exit
    when 'info', 'information', 'cpgui' then on_info
    when 'main', 'main-module' then on_main
    else return false
    end
    true
  end

  def module_console(command, args)
    case command
    when 'modules', 'module', 'mods', 'mod', 'h', 'help' then on_modules
    when 'r', 'rl', 'rel', 'reload', 'ref', 'refresh' then on_reload
    when 'disable', 'disable-module', 'disable-modules' then on_module_disable(args)
    when 'enable', 'enable-module', 'enable-modules' then on_module_enable
    else return false
    end
    true
  end

  def can_disable(args)
    if args.length == 1 || args.length == 2 && args[1].casecmp('confirm')
      begin
        module_class = Kernel.const_get(args[0])
        return module_class if module_class < CPGUI::AppModule

        error 'Invalid module 1!'
      rescue StandardError then error 'Invalid module!' end
    else
      error('Usage: disable <Module>!')
    end
  end

  def on_module_disable(args)
    module_class = can_disable args
    return unless module_class

    disable_message = 'Please use confirm if you really want to disable this!'
    on_self = module_class == self.class && args.length != 2
    send(disable_message) && (return false) if on_self
    @module_manager.disable(module_class)
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
