# frozen_string_literal: true

puts 'Loading module file...'
# The main class of the app
class CPGUI
  # This class handle the modules
  class ModuleManager
    def initialize; end

    def load; end
  end
  # Every module must be a child of this class!
  class AppModule
    def initialize; end
  end
end
puts 'Successfully loaded the module file!'
