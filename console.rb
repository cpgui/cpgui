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
      send Rainbow('Running cpgui...').aqua
      @run = true
      input while @run
    end

    def stop
      send Rainbow('Stopping cpgui...').aqua
      @run = false
    end

    def run?
      @run
    end

    def prefix
      Rainbow('[ConsoleManager] ').aqua
    end

    def send(message)
      puts prefix + message
    end

    attr_reader :cpgui

    private

    def input
      print_prefix
      command = split_input(gets.chomp)
      handle_input(command[:prefix], command[:args]) unless command.nil?
    rescue Interrupt
      puts "\r\n\r\n"
      send Rainbow('Exiting application...').aqua
      @cpgui.stop
      exit
    end

    def handle_input(prefix, args)
      exist = @cpgui.module_manager.console(prefix, args)
      send Rainbow('Command not exist!').red unless exist
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
  end
end
