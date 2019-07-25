# frozen_string_literal: true

require 'json'
# Main module for the cpgui
class MainModule
  def console(command, args)
    return true if module_console(command, args)

    case command
    when 'exit', 'quit', 'close', 'end', 'stop' then command_exit
    when 'info', 'information', 'cpgui' then command_info
    when 'main', 'main-module' then command_main
    else return false
    end
    true
  end

  def module_console(command, args)
    case command
    when 'modules', 'module', 'mods', 'mod', 'h', 'help' then command_modules
    when 'r', 'rl', 'rel', 'reload', 'ref', 'refresh' then command_reload
    when 'disable', 'disable-module' then command_disable(args)
    when 'enable', 'enable-module' then command_enable(args)
    else return false
    end
    true
  end

  def can_disable(args)
    if args.length == 1 || args.length == 2 && args[1].casecmp('confirm')
      begin
        module_class = Kernel.const_get(args[0])
        return module_class if module_class < CPGUI::AppModule

        error 'Invalid module!'
      rescue StandardError then error 'Invalid module!' end
    else
      error 'Usage: disable <Module>!'
    end
  end

  def command_disable(args)
    module_class = can_disable args
    return unless module_class

    disable_message = 'Please use confirm if you really want to disable this!'
    on_self = module_class == self.class && args.length != 2
    if on_self
      send(disable_message)
    else
      @module_manager.disable(module_class)
    end
  end

  def command_main
    send Rainbow("main-#{version}").white
  end

  def command_info
    send Rainbow("cpgui-#{version}").white
  end

  def command_exit
    send Rainbow('Exiting application...').aqua
    @module_manager.cpgui.stop
    puts "\r\n\r\n"
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

  def command_modules
    module_classes = modules
    module_string = module_classes.join(Rainbow(', ').silver)
    output = Rainbow("#{@module_manager.modules.length} module(s): ").aqua
    send output + module_string
  end

  def command_reload
    send Rainbow('Reloading cpgui...').yellow
    @module_manager.stop
    @module_manager.start
    send Rainbow('Successfully reloaded cpgui!').green
  end
end
