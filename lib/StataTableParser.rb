require File.dirname(__FILE__) + '/StataTable.rb'


HORIZONTAL_BORDER = /^-----/

class StataTableParser  
  def initialize(filename)
    @lines = File.read(filename).split(MAC_WIN_UNIX_LINE_BREAKS)
    @table_indexes = nil
    @tables = nil
  end
  
  def num_tables
    table_indexes.length
  end
  
  def first_table
    tables.first
  end
  
  
  def table_indexes
    return @table_indexes if @table_indexes
    @table_indexes = []
    @lines.each_with_index do |line, i|
      @table_indexes << i if line.one_match?(/^\.\ table\ /)
    end
    @table_indexes
  end
  
  def tables
    return @tables if @tables
    @tables = []
    indexes_with_end = table_indexes + [-1] #adding the -1 so that when each_cons is run, it will create slices that proceed all the way to the end of the file.
    indexes_with_end.each_cons(2) do |first, second|
      @tables << StataTable.new(@lines[first..second])
    end
    @tables
  end
  
end


