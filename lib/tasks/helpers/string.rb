class String
  def canonicalize
    self.downcase.gsub(/[^a-z0-9]/,"-").squeeze("-").gsub(/^-/,"").gsub(/-$/,"")
  end
end

