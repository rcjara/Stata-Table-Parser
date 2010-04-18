require File.dirname(__FILE__) + '/TableSegment.rb'

class StataTable
  def initialize(lines)
    @lines = lines
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
  
  def col_names
    return @col_names if @col_names
    @col_names = segments.collect{|seg| seg.col_names }.flatten
    @col_names
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
