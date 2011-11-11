REPO_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

# Using /tmp instead of REPO_ROOT, because chef is being run NOT as sudo
# in order to make homebrew/rvm/etc happy
file_cache_path "/tmp/chef-file-cache"
cookbook_path [File.join(REPO_ROOT, "cookbooks")]
