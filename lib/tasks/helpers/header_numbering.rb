class HeaderNumbering

  attr_accessor :h1, :h2, :h3

  def initialize
    self.h1 = 0
    self.h2 = 0
    self.h3 = 0
  end

  def nextH1
    self.h1 += 1
    self.h2 = 0
    self.h3 = 0
    self.h1.to_s
  end

  def nextH2
    self.h2 += 1
    self.h3 = 0
    "#{self.h1}.#{self.h2}"
  end

  def nextH3
    self.h3 += 1
    "#{self.h1}.#{self.h2}.#{self.h3}"
  end

end


