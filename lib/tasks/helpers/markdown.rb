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
                pf.write "<br/>\n<br/>\n<br/>\n<br/>\n"
                pf.write "<a id='#{h2s[line][1]}'></a>\n"
                pf.write "<a href='#top'>back to top</a>\n"
                pf.write line.gsub(/^##\s/, "## #{numbering.nextH2}. ")
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
