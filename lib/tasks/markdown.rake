namespace :tutorial do
  desc "Builds tutorial pages"
  task :build => :environment do
    options = { :hard_wrap => true, :filter_html => true, :autolink => true, :no_intraemphasis => true, :fenced_code => true, :gh_blockcode => true }

    markdown = Redcarpet::Markdown.new( Redcarpet::Render::HTML, options )

    Dir.glob("{doc}/**/*.mdown").each do |file_name|
      # change fail path from doc/some-file.mdown to app/views/tutuorial/some-file.html
      target = File.join('app/views/tutorial/', "#{file_name.gsub(/^doc\//, '').gsub(/\.mdown$/,'')}.html")

      puts "Converting #{file_name} to #{target}"

      directory = File.dirname(target)
      FileUtils.mkdir_p(directory) unless File.exists?(directory)
      html = markdown.render(File.read(file_name))
      doc = Nokogiri::HTML(html)
      doc.search("//pre/code").each do |pre|
        pre.replace Pygments.highlight(pre.text.rstrip, :lexer => 'ruby')
      end

      File.open(target,"w") do |f|
        f.write(doc.to_s)
      end
    end
  end
end

