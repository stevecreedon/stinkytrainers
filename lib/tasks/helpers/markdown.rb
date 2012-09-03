module Tasks
  module Helpers
    module Markdown
      extend self

      def build_html(from, to)
        require 'tasks/helpers/pygmentize_html'

        options = { :fenced_code_blocks => true }

        markdown = Redcarpet::Markdown.new( PygmentizeHTML.new, options )

        Dir.glob("#{from}**/*.mdown").each do |file_name|
          # change fail path from doc/some-file.mdown to app/views/tutuorial/some-file.html
          target = File.join(to, "#{file_name.gsub(/^#{from}/, '').gsub(/\.mdown$/,'')}.html")

          puts "Converting #{file_name} to #{target}"

          directory = File.dirname(target)
          FileUtils.mkdir_p(directory) unless File.exists?(directory)

          html = markdown.render(File.read(file_name))

          File.open(target,"w") do |f|
            f.write(html)
          end
        end
      end

      def preprocess(from, to)
        require 'tasks/helpers/string'
        require 'tasks/helpers/header_numbering'

        numbering = HeaderNumbering.new

        Dir.glob("#{from}*.mdown").each do |path|
          file = File.open(path, "r")
          
          target = path.gsub(from, to)

          puts "Processing #{path} to #{path.gsub(from, to)}"

          processed_file = File.open(target, "w") do |pf|
            pf.write "<a id='top'></a>\n\n"

            h2s = []

            file.readlines.each do |line|
              if line =~ /^##[^#]/
                h2s << [line, line.gsub(/^##[^a-zA-Z]+/,"").gsub("\n",""), line.canonicalize]
              end
            end

            file.rewind

            file.readlines.each do |line|
              if line =~ /^INDEX/
                h2s.each do |h2|
                  pf.write "1. [#{h2[1]}](##{h2[2]})\n"
                end
              elsif line =~ /^#\s/
                pf.write line.gsub(/#\s/, "# #{numbering.nextH1}. ")
              elsif line =~ /^###\s/
                pf.write line.gsub(/###\s/, "### #{numbering.nextH3}. ") 
              elsif h2s.size > numbering.h2 && h2s[numbering.h2][0] == line
                pf.write %Q{

<div class="fb-comments" data-href="http://www.stinkytrainers.co.uk/rails-tutorial/#{target.gsub(to, "").gsub('mdown', '')}html##{h2s[numbering.h2-1][2]}" data-num-posts="2" data-width="auto"></div>

}
                pf.write "[back to top](#top)\n"
                pf.write line.gsub(/^##\s/, "##<a id='#{h2s[numbering.h2][2]}'></a> #{numbering.nextH2}. ")
              else
                pf.write line
              end
            end

          end
        end
      end
    end
  end
end
