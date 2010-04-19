require File.dirname(__FILE__) + '/StataTableParser.rb'

parser = StataTableParser.new(File.dirname(__FILE__) + "/../TestTables/bigfile.txt")
parser.csv_out
