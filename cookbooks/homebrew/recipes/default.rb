directory node[:homebrew][:prefix] do
  action :create
  owner node[:homebrew][:user]
  group "staff"
end

homebrew_tar = "#{Chef::Config[:file_cache_path]}/mxcl-homebrew.tar.gz"

unless File.exist?("#{node[:homebrew][:prefix]}/bin/brew")
  remote_file homebrew_tar do
    source "http://github.com/mxcl/homebrew/tarball/master"
    owner node[:homebrew][:user]
    group "staff"
    action :create_if_missing
  end

  execute "tar -xzf #{homebrew_tar} -C #{node[:homebrew][:prefix]} --strip 1" do
    user node[:homebrew][:user]
    creates "#{node[:homebrew][:prefix]}/bin/brew"
  end
end

file homebrew_tar do
  action :delete
end

ruby_block "check homebrew" do
  block do
    result = `#{node[:homebrew][:prefix]}/bin/brew --version`
    raise("brew not working: #{result}") unless result.strip.to_f >= 0.7
  end
end

include_recipe "git"

execute "brew update" do
  command "#{node[:homebrew][:prefix]}/bin/brew update"
  user node[:homebrew][:user]
end

execute "brew cleanup" do
  command "#{node[:homebrew][:prefix]}/bin/brew cleanup"
  user node[:homebrew][:user]
  action :nothing
end

node[:homebrew][:formulas].each do |formula|
  package formula
end
