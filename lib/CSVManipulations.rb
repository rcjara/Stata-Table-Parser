require 'kconv'

module CSVManipulations

  def self.convertToUnix(file_name) 
    text = File.read(file_name).toutf8
    begin 
      text.gsub!("\r","\n")
    rescue Exception => e
      puts e
    end
    File.open(file_name, 'w') do |w|
      w << text
    end
  end

  def self.removeCommasFromNumbersInsideQuotes(line) 
    quote_blocks = line.scan(/\"\d[\d|\,]+?\"/)
    cleaned_quote_blocks = quote_blocks.collect { |qb| qb.gsub(",","") }
    quote_blocks.each_with_index { |qb, i| line.gsub!(qb, cleaned_quote_blocks[i] ) }
    line
  end
end
