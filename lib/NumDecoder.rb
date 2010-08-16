class NumDecoder
  def self.decode(string)
    #exit if there is no work to be done
    return string.to_i if string.to_i.to_s == string.to_s    

    #detect if the string is in scientific notation
	if string.scan(/\d\.\d+E\d+/).length == 1
      NumDecoder.decode_scientific(string)
	end

    #not sure what else to try.  How about commas?
    string.gsub(",","").to_f
  end

  def self.decode_scientific(string)
    results = string.scan(/([\d|\.]+)(E)(\d+)/)[0]
	float = results[0].to_f
	multiplier = results[2].to_i
	float * 10 ** multiplier
  end
end

