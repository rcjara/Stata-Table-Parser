require File.dirname(__FILE__) + '/StataTableParser.rb'

parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/OneSimpleTable.txt")
puts parser.first_table.cols.join("\n")



puts "        |  ".index(/\|/)

puts "      0 |   45,469.7     1285953     1535271     393,736    1,275.76".index(/\|/)
puts "      1 |    301,695     281,842     609,266     1400185     938,947".index(/\|/)
puts "      2 |    396,760     440,457     1050901     2045862     1210840".index(/\|/)