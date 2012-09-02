class String
  def canonicalize
    self.downcase.gsub(/[^a-z0-9]/,"-").squeeze("-").gsub(/^-/,"").gsub(/-$/,"")
  end
end

class Numbering
  
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


dir = File.dirname(__FILE__)

numbering = Numbering.new

Dir.glob("#{dir}/*.mdown").each do |path|
  file = File.open(path, "r")
  puts path.gsub("./","processed/")
  processed_file = File.open(path.gsub("./","processed/"), "w") do |pf|
    
    h2s = {}
    
    file.readlines.each do |line|
        if line =~ /^##[^#]/
          h2s[line] = [line.gsub(/^##[^a-zA-Z]+/,"").gsub("\n",""), line.canonicalize]
        end
    end
    
    file.rewind
  
    file.readlines.each do |line|
        if line =~ /^INDEX/
          pf.write "<a id='top'></a>\n\n"          
          h2s.each_value do |h2|
            pf.write "1. [#{h2[0]}](##{h2[1]})\n"
          end
        elsif line =~ /^#\s/
          pf.write line.gsub(/#\s/, "# #{numbering.nextH1}. ")
        elsif line =~ /^###\s/
          pf.write line.gsub(/###\s/, "### #{numbering.nextH3}. ") 
        elsif h2s.has_key?(line)
          pf.write "<br/>\n<br/>\n<br/>\n<br/><a href='#top'>back to top</a>\n"
          pf.write "<a id='#{h2s[line][1]}'></a>\n"
          pf.write line.gsub(/^##\s/, "## #{numbering.nextH2}. ")
        else
          pf.write line
        end
    end
    
  end
  
  
  
  
end