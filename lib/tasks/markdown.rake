require 'tasks/helpers/markdown'

namespace :tutorial do
  desc "Builds tutorial pages"
  task :build => [:environment, :'tutorial:preprocess'] do
    Tasks::Helpers::Markdown.build_html('doc/processed/', 'app/views/tutorial/')
  end

  desc "Preprocesses tutorial pages"
  task :preprocess => :environment do
    Tasks::Helpers::Markdown.preprocess('doc/', 'doc/processed/')
  end
end
