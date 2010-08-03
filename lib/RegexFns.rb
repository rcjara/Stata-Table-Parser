MAC_WIN_UNIX_LINE_BREAKS = /\r|\n|\r\n/

class String
  def one_match?(regex)
    self.scan(regex).length == 1
  end

  def any_match?(regex)
    self.scan(regex).length > 0
  end
end

class NilClass
  def strip
    ""
  end
end
