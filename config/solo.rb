require 'lib/chef-sudo'

REPO_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

# Using /tmp instead of REPO_ROOT, because chef is being run NOT as sudo
# in order to make homebrew/rvm/etc happy
file_cache_path File.join(ENV['HOME'], 'chef-solo')
cookbook_path [File.join(REPO_ROOT, "cookbooks")]

# and since we aren't root, specify where cache goes
local_cache = File.join(ENV['HOME'], '.cache', 'chef-solo')
Chef::Config[:cache_options][:path] = File.join(local_cache, 'cache')
Chef::Config[:file_backup_path] = File.join(local_cache, 'backup')
