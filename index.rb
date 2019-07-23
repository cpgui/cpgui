# frozen_string_literal: true
require 'rainbow'
puts Rainbow('[Loader] ').aqua + Rainbow('Welcome to the CPGUI! Starting app...').yellow
require_relative './module.rb'
require_relative './console.rb'
require_relative './app.rb'
puts Rainbow('[Loader] ').aqua + Rainbow('Reading module folder...').yellow
Dir[File.join('./modules/', '**/*.rb')].each do |file|
  puts Rainbow('[Loader] ').aqua + Rainbow("Including #{file}...").yellow
  require_relative file
  puts Rainbow('[Loader] ').aqua + Rainbow("Successfully included #{file}!").green
end
bot_modules = []
puts Rainbow('[Loader] ').aqua + Rainbow('Successfully read module folder!').green
app = CPGUI.new(bot_modules)
puts Rainbow('[Loader] ').aqua + Rainbow('Welcome to the CPGUI! Successfully started app!').green
app.run
