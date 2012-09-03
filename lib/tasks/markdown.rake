require 'tasks/helpers/markdown'

namespace :tutorial do
  desc "Builds tutorial pages"
  task :build => [:environment, :'tutorial:preprocess', :'tutorial:build_slidebar'] do
    Tasks::Helpers::Markdown.build_html('doc/processed/', 'app/views/tutorial/')
  end

  desc "Preprocesses tutorial pages"
  task :preprocess => :environment do
    Tasks::Helpers::Markdown.preprocess('doc/', 'doc/processed/', '/rails-tutorial/')
  end

  desc "Builds slidebar"
  task :build_slidebar => :environment do
    Tasks::Helpers::Markdown.build_slidebar('doc/processed/', '/rails-tutorial/')
  end
end
