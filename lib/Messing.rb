require File.dirname(__FILE__) + '/StataTableParser.rb'

# parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/SmallWideTable.txt")
# array = parser.first_table.to_a
# puts array.inspect


puts "hi" if "               Business Services |         970,479          3455593          5104552          6289118          1490657".one_match?(/^\s*?\S[^\|]+?\s*?\|+?/)
puts "bye"