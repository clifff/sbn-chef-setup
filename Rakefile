require "rubygems"
require 'rake'

namespace :chef do
  def rvm_installed?
    !`which rvm`.empty?
  end

  desc "install chef if needed"
  task :install do
    begin
      Gem::Specification::find_by_name 'chef'
    rescue Exception => e
      if rvm_installed?
        sh "gem install chef --no-rdoc --no-ri"
      else
        sh "sudo gem install chef --no-rdoc --no-ri"
      end
    end
  end
  desc "run chef-solo using the config and json files stored in ./config"
  task :run do
    sh "sudo chef-solo -c ./config/solo.rb -j ./config/node.json -l debug"
  end
end

task :chef => [
  'chef:install',
  'chef:run'
]
