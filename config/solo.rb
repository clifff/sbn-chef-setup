REPO_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

file_cache_path REPO_ROOT
cookbook_path [File.join(REPO_ROOT, "cookbooks-vendor")]
