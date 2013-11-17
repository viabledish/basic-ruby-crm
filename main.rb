require 'pry'
require 'pry-debugger'

require_relative 'database'
require_relative 'contact'
require_relative 'phone'
require_relative 'application'
 
Application.new.run
