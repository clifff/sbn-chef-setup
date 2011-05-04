require "rubygems"

CURRENT_DIR = File.dirname(__FILE__)
REPO_ROOT = "/tmp/chef-solo"
COOKBOOKS_URL = "http://github.com/twelvelabs/osx-cookbooks/tarball/master"


namespace :chef do
  
  desc "install chef"
  task :install do
    sh "sudo gem update --system"
    if Gem.available?("chef")
      puts "chef already installed..."
    else
      sh "sudo gem install chef --no-rdoc --no-ri"
    end
  end

  desc "copy chef configuration files to #{REPO_ROOT}"
  task :config do
    rm_rf "#{REPO_ROOT}"
    mkdir_p "#{REPO_ROOT}"
    mkdir_p "#{REPO_ROOT}/cookbooks"
    cp_r "#{CURRENT_DIR}/config/solo.rb", "#{REPO_ROOT}/solo.rb"
    cp_r "#{CURRENT_DIR}/config/node.json", "#{REPO_ROOT}/node.json"
    # copy the cookbooks into the REPO_ROOT...
    # can't just pass the URL to chef-solo because it barfed on the HTTP redirects, so we do it manually
    sh "curl -sL #{COOKBOOKS_URL} | tar -xz -C #{REPO_ROOT}/cookbooks -m --strip 1"
  end

  desc "run the chef configuration defined in #{REPO_ROOT}"
  task :run do
    sh "sudo chef-solo -c '#{REPO_ROOT}/solo.rb' -j '#{REPO_ROOT}/node.json'"
  end

end

desc "install, config, and run chef"
task :chef => [
  "chef:install", 
  "chef:config", 
  "chef:run"
]


