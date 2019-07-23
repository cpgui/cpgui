# frozen_string_literal: true

class MainModule
  def console(command, _args)
    if %w[exit quit close end stop].include? command
      puts 'Exiting application...'
      exit
    elsif %w[info cpgui information].include? command
      puts "cpgui-#{CPGUI.version}"
      true
    elsif %w[main main-module].include? command
      puts "main-#{MainModule.version}"
      true
    end
  end
end
