# frozen_string_literal: true

puts 'Welcome to the CPGUI! Starting app...'
require_relative './module.rb'
require_relative './app.rb'
# @type [CPGUI]
app = CPGUI.new
app.run
