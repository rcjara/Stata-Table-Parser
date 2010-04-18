require File.dirname(__FILE__) + '/CSVManipulations.rb'
require File.dirname(__FILE__) + '/RegexFns.rb'
require "Set"

HORIZONTAL_BORDER = /^-----/

class StataTableParser  
  def initialize(filename)
    @lines = File.read(filename).toutf8.split(MAC_WIN_UNIX_LINE_BREAKS)
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
    indexes_with_end = table_indexes + [-1]
    indexes_with_end.each_cons(2) do |first, second|
      @tables << StataTable.new(@lines[first..second])
    end
    @tables
  end
  
end


class StataTable
  def initialize(lines)
    @lines = lines
  end
  
  def num_cols
    cols.length
  end
  
  def num_rows
    rows.length
  end
  
  def cols
    return @cols if @cols
    cols_set = SortedSet.new
    cols_set.add(start_of_rows)
    @lines[start_of_rows...(start_of_rows + num_rows)].each do |line|
      offset = start_of_cols
      loop do
        result = line.index(/\S\s/, offset)
        break unless result
        cols_set.add(result)
      end
    end
    @cols = cols_set.to_a[0...-1]
  end
  
  def rows
    return @rows if @rows
    found_end = false
    @rows = @lines[start_of_rows..-1].select do |line|
      found_end ||= line.one_match?(HORIZONTAL_BORDER)
      !found_end
    end
    @rows
  end
  
  def start_of_rows
    return @start_of_rows if @start_of_rows
    
    num_borders = 0
    
    @lines.each_with_index do |line, i|
      if line.one_match?(HORIZONTAL_BORDER)
        num_borders += 1
        if num_borders == 2
          @start_of_rows = i + 1
          break
        end
      end
    end
    @start_of_rows
  end
  
  def start_of_cols
    return @start_of_cols if @start_of_cols
    @start_of_cols = @lines[start_of_rows].index("|") + 1
    @start_of_cols
  end
  
  
end
