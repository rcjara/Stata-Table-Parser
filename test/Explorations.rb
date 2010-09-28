require File.dirname(__FILE__) + '/../lib/StataTableParser.rb'
require File.dirname(__FILE__) + '/StataTableParserHelper.rb'

include StataTableParserHelper

@parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/SmallWideTable.txt")
@parser.xml_out(File.dirname(__FILE__) + "/../TestTables/SmallWideTableBasicOut.xml", :row_totals => true)
