require File.dirname(__FILE__) + '/StataTable.rb'


HORIZONTAL_BORDER = /^-----/

class StataTableParser  
  def initialize(filename)
    @filename = filename
    @lines = File.read(filename).split(MAC_WIN_UNIX_LINE_BREAKS)
  end
  
  def csv_out(filename = nil, options = {})
    unless filename
      filename = @filename.gsub(/\.txt|\.log/, ".csv")
    end
    File.open(filename, 'w') do |w|
      tables.each do |table|
        # table.print
        w << table.to_csv
        w << "\n\n"
        # puts "<<<<<<<<<good>>>>>>>>"
      end
    end
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
      @table_indexes << i if line.one_match?(/^\.\s+tab/)
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
  
  def table_types
    tables.collect { |table| table.table_type }
  end
end


