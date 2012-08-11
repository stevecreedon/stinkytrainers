namespace :tutorial do
  desc "Builds tutorial pages"
  task :build => :environment do
    options = { :fenced_code_blocks => true }

    markdown = Redcarpet::Markdown.new( PygmentizeHTML.new, options )

    Dir.glob("{doc}/**/*.mdown").each do |file_name|
      # change fail path from doc/some-file.mdown to app/views/tutuorial/some-file.html
      target = File.join('app/views/tutorial/', "#{file_name.gsub(/^doc\//, '').gsub(/\.mdown$/,'')}.html")

      puts "Converting #{file_name} to #{target}"

      directory = File.dirname(target)
      FileUtils.mkdir_p(directory) unless File.exists?(directory)

      html = markdown.render(File.read(file_name))

      File.open(target,"w") do |f|
        f.write(html)
      end
    end
  end
end


class PygmentizeHTML < Redcarpet::Render::HTML
  def block_code(code, language)
    require 'pygmentize'
    Pygmentize.process(code, language)
  end
end