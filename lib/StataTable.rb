require File.dirname(__FILE__) + '/TableSegment.rb'
require File.dirname(__FILE__) + '/TabSegment.rb'
require File.dirname(__FILE__) + '/NumDecoder.rb'
require "htmlentities"

class StataTable
  attr_reader :table_type

  @@coder = HTMLEntities.new 

  def initialize(lines)
    @command = lines[0]

	@table_type = if @command.one_match?(/table\s/)
		:table
	elsif @command.one_match?(/(tab)(\s|ulate)/)
		:tab
	elsif @command.one_match?(/tabdisp/)
		:tabdisplay
	end

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

  def to_xml(options = {})
    self.to_a.collect.with_index do |line_array, i|
	  s = "   <Row>\n"
      s << line_array.collect.with_index do |element, j|
        style = get_style(i, j, line_array.length)

		if i <= @num_header_lines || j == 0 
			data_type = "String"
			cleaned_element = @@coder.encode(element, :named)
		else
			data_type = "Number"
			cleaned_element = NumDecoder::decode(element)
		end

        unless element.empty? 
          "    <Cell #{style}><Data ss:Type=\"#{data_type}\">#{cleaned_element}</Data></Cell>\n"
		else
          "    <Cell #{style}/>\n"
	    end
	  end.join
	  if options[:row_totals]
		style = get_total_style(i)
		s << if i > 0 && i < @num_header_lines
		  "    <Cell #{style}/>\n"
		elsif i == @num_header_lines
		  "    <Cell #{style}><Data ss:Type=\"String\">Total</Data></Cell>\n"
		elsif i > 0
		  "    <Cell #{style} ss:Formula=\"=SUM(RC[-#{num_cols}]:RC[-1])\"></Cell>\n"
		else
		  ""
		end
	  end
	  s << "   </Row>\n"
	  s
	end.join
  end

  #the style for row totals
  def get_total_style(i)
    style_id = case i
	when 0...@num_header_lines
	  "s31"
	when @num_header_lines
	  "s42"
	else
	  "s31"
	end
	style_id.empty? ? "" : " ss:StyleID=\"#{style_id}\""
  end

  def get_style(i, j, j_len)
    style_id = case i
	when 0
	  ""
    when 1
      case j
	  when 0
	    "s27"
	  when 1...(j_len - 1)
	    "s28"
	  else
	    "s29"
	  end
    when 1...@num_header_lines
      case j
	  when 0
	    "s30"
	  when 1...(j_len - 1)
	    "s31"
	  else
        "s32"
	  end
    when @num_header_lines
      case j
	  when 0
	    "s33"
	  when 1...(j_len - 1)
	    "s34"
	  else
		"s35"
	  end
	when (@num_header_lines + 1)..(num_rows + 1)
      case j
	  when 0
	    "s36"
	  when 1...(j_len - 1)
	    "s37"
	  else
        "s38"
	  end
	else
      case j
	  when 0
	    "s39"
	  when 1...(j_len - 1)
	    "s40"
	  else
		"s41"
	  end
	end
	style_id.empty? ? "" : " ss:StyleID=\"#{style_id}\""
  end
  
  def to_a
    return @as_array if @as_array
    @as_array = []
    @as_array << [@command]
    @num_header_lines = 1 

	unless col_var_name.empty? | col_var_name.one_match?(HORIZONTAL_BORDER)
	  @num_header_lines += 1
      first_line = []
      (num_cols / 2).times { first_line << create_intersection("") }
      first_line << create_intersection(col_var_name)
      (num_cols - first_line.length + 1).times { first_line << create_intersection("") }
      @as_array << first_line.flatten
	end
    
    second_line = []
    second_line << row_var_name
    second_line << col_names.collect{|col_name| create_intersection(col_name) }
    @as_array << second_line.flatten
    
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
  
  def num_cells
    segments.first.num_cells
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

	border = case @table_type
	when :tab
	  /\|/
	else
	  HORIZONTAL_BORDER
	end

	segment = nil
	    
    loop do
      until @lines[i].any_match?(border)
        i += 1
        break if i >= @lines.length 
      end
      current_lines = @lines[i..-1] 
	  segment = case @table_type
      when :tab
        TabSegment.new(current_lines)
      else
        TableSegment.new(current_lines)
	  end

      if segment.verify!
        @segments << segment
	  else
		break
	  end
	  i += segment.height
	  break if i >= @lines.length
    end

	raise "No segments found:\n #{segment.lines.join("\n")}" if @segments.empty?
    
    @segments
  end
  
  def create_intersection(text)
    intersection_array = [text]
    (num_cells - 1).times { intersection_array << "" }
    intersection_array
  end
  
end
