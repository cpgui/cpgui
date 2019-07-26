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

  def command_enable(args)
    unless args.length == 1
      error Rainbow('Usage: enable <Module>!').red
      return false
    end
    module_class = module_by_name args[0]
    return false unless module_class

    @module_manager.enable(module_class)
  end

  def can_command_disable(args)
    length = args.length
    is_confirm = length == 2 && args[1].casecmp('confirm')
    unless length == 1 || is_confirm
      error('Usage: disable <Module>!')
      return nil
    end
    module_class = module_by_name args[0]
    return nil unless module_class

    module_class
  end

  def command_disable(args)
    module_class = can_command_disable args
    return unless module_class

    if module_class == self.class && !args.length == 2
      send 'Please use confirm if you really want to disable this!'
      return false
    end
    send Rainbow("Disabling #{args[0]}...").yellow
    @module_manager.disable(module_class)
    send Rainbow("Successfully disabled #{args[0]}!").green
    true
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

  private

  def module_by_name(name)
    module_class = Kernel.const_get(name)
    return module_class if module_class < CPGUI::AppModule

    error 'Invalid module!'
  rescue StandardError then error 'Invalid module!'
  end
end
