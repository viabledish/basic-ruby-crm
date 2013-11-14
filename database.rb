require 'active_record'
require 'logger'
ActiveRecord::Base.logger = Logger.new(STDOUT)
 
print "Establishing connection to database ..."
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => "./db/db.sqlite"
)
 
puts "CONNECTED"
