require 'active_record'
 
print "Establishing connection to database ..."
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => "./db/db.sqlite"
)
 
puts "CONNECTED"
