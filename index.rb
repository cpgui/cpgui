# frozen_string_literal: true

puts 'Welcome to the CPGUI! Starting app...'
require_relative './module.rb'
require_relative './app.rb'
puts 'Reading module folder...'
Dir[File.join('./modules/', '**/*.rb')].each do |file|
  puts "Including #{file}..."
  require_relative file
  puts "Successfully included #{file}!"
end
bot_modules = []
puts 'Adding modules...'
module_classes = ObjectSpace.each_object(Class).select do |c|
  c.included_modules.include? AppModule
end
module_classes.each do |app_module_class|
  bot_modules.push(app_module_class.new)
end
puts 'Successfully readed module folder!'
app = CPGUI.new
app.run
