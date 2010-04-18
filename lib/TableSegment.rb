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
    line = @lines[start_of_rows]
    @start_of_cols = line.index('|') + 1
    @start_of_cols
  end
  
  
end