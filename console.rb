# frozen_string_literal: true

require 'rainbow'
require 'socket'
class CPGUI
  # Handle the console commands
  class ConsoleManager
    def initialize(cpgui)
      @cpgui = cpgui
    end

    # Run the console manager
    def run
      send Rainbow('Running cpgui...').aqua
      @run = true
      input while @run
    end

    # Stop the console manager
    def stop
      send Rainbow('Stopping cpgui...').aqua
      @run = false
    end

    # Test if console manager is running
    def run?
      @run
    end

    # The prefix of the console manager
    def prefix
      Rainbow('[ConsoleManager] ').aqua
    end

    # Send the message with the prefix
    def send(message)
      puts prefix + message
    end

    attr_reader :cpgui

    private

    def input
      print_prefix
      handle_input
    rescue Interrupt
      puts "\r\n"
      send Rainbow('Exiting application...').aqua
      @cpgui.stop
      puts "\r\n\r\n"
      exit
    end

    def handle_input
      command = split_input(gets)
      return false if command.nil?

      exist = @cpgui.module_manager.console(command[:prefix], command[:args])
      send Rainbow('Command not exist!').red unless exist
    end

    def print_prefix
      info = Rainbow("cpgui-#{@cpgui.version}").green.bold
      pc = Rainbow(ENV['USERNAME']).blue.bold
      print info + ':' + pc + Rainbow('$ ').yellow
    end

    def split_input(input)
      input = input.chomp
      input_list = input.split(' ')
      return if input_list.empty?

      command_prefix = input_list[0]
      command_args = input_list[1..-1]
      { prefix: command_prefix, args: command_args }
    end
  end
end
