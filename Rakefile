require "rubygems"
require 'rake'

namespace :chef do
  def rvm_installed?
    !`which rvm`.empty?
  end
  
  def ensure_gem_installed(gem_name)
    begin
      Gem::Specification::find_by_name gem_name
    rescue Exception => e
      prefix = rvm_installed? ? 'sudo' : ''
      sh "#{prefix} gem install #{gem_name} --no-rdoc --no-ri"
    end
  end

  desc "install chef if needed"
  task :install do
    ensure_gem_installed('chef')
    ensure_gem_installed('chef-sudo')
  end
  desc "run chef-solo using the config and json files stored in ./config"
  task :run do
    sh "chef-solo -c ./config/solo.rb -j ./config/node.json -l debug"
  end
end

task :chef => [
  'chef:install',
  'chef:run'
]
