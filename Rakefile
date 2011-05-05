require "rubygems"

CURRENT_DIR = File.expand_path(File.dirname(__FILE__))
REPO_ROOT="/var/chef-solo"
VENDOR_COOKBOOKS_URL="http://github.com/twelvelabs/osx-cookbooks/tarball/master"


namespace :chef do
  
  task :install do
    unless Gem.available? 'chef'
      sh "gem install chef --no-rdoc --no-ri"
    end
  end
  
  task :config do
    rm_rf REPO_ROOT
    mkdir_p REPO_ROOT
    cp_r "#{CURRENT_DIR}/config",           "#{REPO_ROOT}/config"
    cp_r "#{CURRENT_DIR}/cookbooks",        "#{REPO_ROOT}/cookbooks"
    cp_r "#{CURRENT_DIR}/cookbooks-vendor", "#{REPO_ROOT}/cookbooks-vendor"
    sh "curl -sL #{VENDOR_COOKBOOKS_URL} | tar -xz -C '#{REPO_ROOT}/cookbooks-vendor' -m --strip 1"
  end
  
  task :run do
    sh "chef-solo -c '#{REPO_ROOT}/config/solo.rb' -j '#{REPO_ROOT}/config/node.json'"
  end
  
end

task :chef => [
  'chef:install',
  'chef:config',
  'chef:run'
]