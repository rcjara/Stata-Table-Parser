require "Set"
require File.dirname(__FILE__) + '/CSVManipulations.rb'
require File.dirname(__FILE__) + '/RegexFns.rb'

class TableSegment
  def initialize(lines)
    @lines = lines
  end
  
  def verify!
    start_point = nil
    end_point = nil
    num_borders = 0
    @lines.each_with_index do |line, i|
      if line.one_match?(HORIZONTAL_BORDER)
        num_borders += 1
        if num_borders == 1
          start_point = i
        end
        if num_borders == 3
          end_point = i
          break
        end
      end
      if line.one_match?(/^\.\ \S/) #found a new command
        break
      end
    end
    return false unless end_point
    @lines = @lines[start_point..end_point]
    true
  end
  
  def height
    @lines.length
  end
  
  def num_cols
    cols.length
  end
  
  def num_rows
    rows.length
  end
  
  def grab_row(row_num)
    row_array = []
    line = @lines[start_of_rows + row_num]
    cols.each_cons(2) do |start, finish|
      row_array << line[start...finish].strip
    end
    row_array << line[cols.last..-1].strip
    row_array
  end
  
  
  def cols
    return @cols if @cols
    @cols = SortedSet.new
    @cols.add(start_of_cols)
    @lines[start_of_rows...(start_of_rows + num_rows)].each do |line|
      offset = start_of_cols
      loop do
        result = line.index(/\S\s/, offset)
        break unless result
        offset = result + 1
        @cols.add(offset)
      end
    end
    
    @cols = @cols.to_a
    @cols
  end
  
  def col_names
    return @col_names if @col_names
    @col_names = []
    line = @lines[start_of_rows - 2]
    cols.each_cons(2) do |start, finish|
      @col_names << line[start...finish].strip
    end
    @col_names << line[cols.last..-1].strip
    @col_names
  end
  
  def col_var_name
    return @col_var_name if @col_var_name
    @col_var_name = @lines[start_of_rows - 3][start_of_cols..-1].strip
    @col_var_name
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
  
  def row_names
    return @row_names if @row_names
     
     column_border = start_of_cols - 2
    @row_names = @lines[start_of_rows...(start_of_rows + num_rows)].collect do |line|
      line[0..column_border].strip
    end
    
    @row_names
  end
  
  def row_var_name
    return @row_var_name if @row_var_name
    @row_var_name = @lines[start_of_rows - 2][0..(start_of_cols - 2)].strip
    @row_var_name
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
    line = @lines[start_of_rows]
    @start_of_cols = line.index('|') + 1
    @start_of_cols
  end
  
  
end