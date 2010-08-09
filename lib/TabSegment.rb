require File.dirname(__FILE__) + '/TableSegment.rb'

class TabSegment < TableSegment

  def verify!
    start_point = nil
    end_point = nil
    num_borders = 0
    @lines.each_with_index do |line, i|
      if line.one_match?(HORIZONTAL_BORDER)
        num_borders += 1
        if num_borders == 1
          start_point = i - 1
        end
        if num_borders == 2
          end_point = i + 1
          break
        end
      end
      if line.one_match?(/^\.\ \S/) #found a new command
        break
      end
    end
    unless end_point
	  return false 
	end
    @lines = @lines[start_point..end_point] 
	@command = :tab
    true
  end

  def start_of_rows
    return @start_of_rows if @start_of_rows
    
    num_borders = 0
    
    @lines.each_with_index do |line, i|
      if line.one_match?(HORIZONTAL_BORDER)
        num_borders += 1
        if num_borders == 1
          @start_of_rows = i + 1
          break
        end
      end
    end
    @start_of_rows
  end
  
  def rows
    return @rows if @rows
    found_end = false
	pre_end = false
    @num_cells = 1
    cur_num_cells = 0
	num_borders = 0
    @rows = (start_of_rows...@lines.length).select do |line_num|
      line = @lines[line_num]
      has_var_name = if line.one_match?(/^\s*?\S[^\|]+?\s*?\|+?/)
        cur_num_cells = 0
        true
      else
        cur_num_cells += 1
        @num_cells = cur_num_cells if cur_num_cells > @num_cells
        false
      end
      
      #need to take the line after we have found two borders.  Hence this messiness
	  num_borders += 1 if line.one_match?(HORIZONTAL_BORDER)
      found_end = pre_end
      pre_end = true if num_borders == 2

      !found_end && has_var_name
    end
    @rows
  end
end
