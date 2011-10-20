require "Set"
require File.expand_path(File.dirname(__FILE__)) + '/CSVManipulations.rb'
require File.expand_path(File.dirname(__FILE__)) + '/RegexFns.rb'

class TableSegment
  attr_reader :command, :lines

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
        if num_borders >= 3
          end_point = i
          if i < @lines.length
            break if @lines[i + 1] =~ /^\s*$/
          else
            break
          end
        end
      end
      if line.one_match?(/^\.\ \S/) #found a new command
        break
      end
    end
    return false unless end_point
    @lines = @lines[start_point..end_point]
    @command = :table
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
    cols.each_cons(2) do |start, finish|
      row_array << (0...num_cells).collect do |offset|
        line = @lines[rows[row_num] + offset]
        line[start...finish].strip
      end
    end
    row_array << (0...num_cells).collect do |offset|
      line = @lines[rows[row_num] + offset]
      line[cols.last..-1].strip
    end
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

    @col_var_name = if start_of_rows >= 3
      @lines[start_of_rows - 3][start_of_cols..-1].strip
    else
      ""
    end

    @col_var_name
  end

  def rows
    return @rows if @rows
    found_end = false
    @num_cells = 1
    cur_num_cells = 0
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
      found_end ||= (line_num >= @lines.length) || (line.one_match?(HORIZONTAL_BORDER) && @lines[line_num + 1] =~ /^\s*$/)
      !found_end && has_var_name
    end
    @rows
  end

  def num_cells
    return @num_cells if @num_cells
    rows
    @num_cells
  end

  def row_names
    return @row_names if @row_names

    column_border = start_of_cols - 2
    @row_names = rows.collect do |line_num|
      @lines[line_num][0..column_border].strip
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
