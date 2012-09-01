class String
  def canonicalize
    self.downcase.gsub(/[^a-z0-9]/,"-").squeeze("-").gsub(/^-/,"").gsub(/-$/,"")
  end
end


dir = File.dirname(__FILE__)

Dir.glob("#{dir}/*.mdown").each do |path|
  file = File.open(path, "r")
  puts path.gsub("./","processed/")
  processed_file = File.open(path.gsub("./","processed/"), "w") do |pf|
    
    h2s = []
    
    file.readlines.each do |line|
        if line =~ /^##[^#]/
          h2s << [line.gsub(/^##[^a-zA-Z]+/,"").gsub("\n",""), line.canonicalize]
        end
    end
    
    file.rewind
    
    file.readlines.each do |line|
      puts line
        if line =~ /^INDEX/
          h2s.each do |h2|
            pf.write "1. [#{h2[0]}](##{h2[1]})\n"
          end
        else
          pf.write line
        end
    end
    
  end
  
  
  
  
end