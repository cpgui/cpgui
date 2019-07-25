# frozen_string_literal: true

require 'rainbow'
require 'socket'
class CPGUI
  # Handle the console commands
  class ConsoleManager
    def initialize(cpgui)
      @cpgui = cpgui
    end

    def run
      @run = true
      input while @run
    end

    private

    def input
      print_prefix
      command = split_input(gets.chomp)
      handle_input(command[:prefix], command[:args]) unless command.nil?
    rescue Interrupt
      puts "\r\n\r\n" + Rainbow('Exiting application...').cyan
      exit
    end

    def handle_input(prefix, args)
      exist = @cpgui.module_manager.console(prefix, args)
      puts Rainbow('Command not exist!').red unless exist
    end

    def print_prefix
      info = Rainbow("cpgui-#{@cpgui.version}").green.bold
      pc = Rainbow(ENV['USERNAME']).blue.bold
      print info + ':' + pc + Rainbow('$ ').yellow
    end

    def split_input(input)
      input_list = input.split(' ')
      return if input_list.empty?

      command_prefix = input_list[0]
      command_args = input_list[1..-1]
      { prefix: command_prefix, args: command_args }
    end

    def stop
      @run = false
    end

    def run?
      @run
    end
  end
end
