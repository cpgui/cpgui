# frozen_string_literal: true

require 'rainbow'

prefix = Rainbow('[Loader] ').aqua
puts prefix + Rainbow('Welcome to the CPGUI! Starting app...').yellow
require_relative './module.rb'
require_relative './console.rb'
require_relative './app.rb'
puts prefix + Rainbow('Reading module folder...').yellow
Dir[File.join('./modules/', '**/*.rb')].each do |file|
  puts prefix + Rainbow("Including #{file}...").yellow
  require_relative file
  puts prefix + Rainbow("Successfully included #{file}!").green
end
bot_modules = []
puts prefix + Rainbow('Successfully read module folder!').green
app = CPGUI.new(bot_modules)
puts prefix + Rainbow('Welcome to the CPGUI! Successfully started app!').green
app.run
