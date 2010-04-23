require File.dirname(__FILE__) + '/StataTableParser.rb'

parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/SmallWideTable.txt")
array = parser.first_table.to_a
puts array.inspect
