dir = File.dirname(__FILE__)

Dir.glob("#{dir}/*.mdown").each do |path|
  file = File.open(path)
  puts path.gsub("./","processed/")
  processed_file = File.open(path.gsub("./","processed/"), "w") do |pf|
    
    file.readlines.each do |line|
     pf.write line if line =~ /^##[^#]/
    end
  
  end
  
  
  
  
end