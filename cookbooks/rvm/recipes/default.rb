require 'shellwords'

package "git"

rvm_git = "#{Chef::Config[:file_cache_path]}/rvm"
prefix = node[:rvm][:prefix]

execute "git clone https://github.com/wayneeseguin/rvm.git #{rvm_git}" do
  not_if { File.exist?(rvm_git) || File.exist?("#{prefix}rvm") }
end


ENV['rvm_path']="#{prefix}/rvm"


execute "#{rvm_git}/install" do
  cwd "#{rvm_git}"
  user node[:rvm][:user]
  not_if { File.exist?("#{prefix}rvm") }
end


user_path = "/Users/#{node[:rvm][:user]}/"

execute "mv #{user_path}.bash_profile #{user_path}.bash_profile.original" do
  only_if { File.exist?("#{user_path}.bash_profile") }
end

template "#{user_path}.bash_profile" do
  source "bash_profile.erb"
  variables(
    :user_path => user_path
  )
end

execute "#{user_path}.bash_profile"

node[:rvm][:rubies].each do |ruby|
  bash "rvm install #{ruby}" do
    code <<-EOS
      export rvm_path=#{node[:rvm][:prefix]}rvm
      source "#{node[:rvm][:prefix]}rvm/scripts/rvm"
      rvm install #{ruby}
    EOS
    not_if <<-EOS
      export rvm_path=#{node[:rvm][:prefix]}rvm
      source "#{node[:rvm][:prefix]}rvm/scripts/rvm"
      rvm list | grep #{ruby}
   EOS
    user node[:rvm][:user]
  end
end
