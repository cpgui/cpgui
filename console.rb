# frozen_string_literal: true

puts 'Loading console file...'
require 'colorize'
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
      command = handle_input(gets.chomp)
      mm = @cpgui.module_manager
      return if command.nil?

      exist = mm.console(command[:prefix], command[:args])
      puts 'Command not exist!'.red unless exist
    rescue Interrupt
      puts "\r\n\r\nExiting application..."
      exit
    end

    def print_prefix
      prefix = "cpgui-#{CPGUI.version}".green.bold
      current_directory = Dir.pwd.blue.bold + '$ '
      print prefix + ':' + current_directory
    end

    def handle_input(input)
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

puts 'Successfully loaded console file!'
