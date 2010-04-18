require File.dirname(__FILE__) + '/StataTableParser.rb'

parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/OneDoubleWideTable.txt")
puts parser.first_table.cols.join("\n")
# 
# 
# puts "fun\nby\nthe\nsun".split(MAC_WIN_UNIX_LINE_BREAKS).length
# 
# puts File.read(File.dirname(__FILE__) + "/../TestTables/OneDoubleWideTable.txt").split(MAC_WIN_UNIX_LINE_BREAKS).length