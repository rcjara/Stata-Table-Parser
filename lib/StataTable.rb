require File.dirname(__FILE__) + '/TableSegment.rb'

class StataTable
  def initialize(lines)
    @command = lines[0]
    @lines = lines
  end
  
  def print
    @lines.each { |line| puts line }
  end
  
  
  def to_csv
    self.to_a.collect do |line_array|
      "\"#{line_array.join("\",\"")}\""
    end.join("\n")
  end
  
  def to_a
    return @as_array if @as_array
    @as_array = []
    @as_array << [@command]
    
    first_line = []
    (num_cols / 2).times { first_line << ""}
    first_line << col_var_name
    (num_cols - first_line.length).times {first_line << "" }
    @as_array << first_line
    
    second_line = []
    second_line << row_var_name
    second_line << col_names
    @as_array << second_line
    
    (0...num_rows).each do |i|
      line = []
      line << row_names[i]
      segments.each do |segment|
        line << segment.grab_row(i)
      end
      @as_array << line.flatten
    end
    @as_array
  end
  
  def num_cols
    return @num_cols if @num_cols
    
    @num_cols = segments.inject(0) do |sum, segment|
      sum + segment.num_cols
    end
    
    @num_cols
  end
  
  def num_rows
    return @num_rows if @num_rows
    
    @num_rows = segments.first.num_rows
    
    @num_rows
  end
  
  def num_segments
    segments.length
  end
  
  def row_names
    return @row_names if @row_names
    @row_names = segments.first.row_names
    @row_names
  end
  
  def row_var_name
    return @row_var_name if @row_var_name
    @row_var_name = segments.first.row_var_name
    @row_var_name
  end
  
  
  def col_names
    return @col_names if @col_names
    @col_names = segments.collect{|seg| seg.col_names }.flatten
    @col_names
  end
  
  def col_var_name
    return @col_var_name if @col_var_name
    @col_var_name = segments.first.col_var_name
    @col_var_name
  end
  
  
  def cols
    
  end
  
  def rows
    
  end
  
  def segments
    return @segments if @segments
    
    @segments = []
    
    i = 0
    loop do
      until @lines[i].one_match?(HORIZONTAL_BORDER)
        i += 1
        break if i >= @lines.length 
      end
      segment = TableSegment.new(@lines[i..-1])
      break unless segment.verify!
      @segments << segment
      i += segment.height
      break if i >= @lines.length 
    end
    
    @segments
  end
  
  
end
