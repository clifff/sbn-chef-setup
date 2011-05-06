require "rubygems"

namespace :chef do
  desc "install chef if needed"
  task :install do
    unless Gem.available? 'chef'
      sh "gem install chef --no-rdoc --no-ri"
    end
  end
  desc "run chef-solo using the config and json files stored in ./config"
  task :run do
    sh "chef-solo -c ./config/solo.rb -j ./config/node.json"
  end
end

task :chef => [
  'chef:install',
  'chef:run'
]
