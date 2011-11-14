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
  owner   node[:rvm][:user]
  mode    "777"
  variables(
    :rvm_path => ENV['rvm_path'],
    :user_path => user_path
  )
end


bash "install sbn default gemset" do
  default_gemset = node[:rvm][:default_gemset]
  default_ruby = default_gemset[0...default_gemset.index('@')]

  # NOTE: When installing, the removing/export CC/force install is neccesary
  # because of some weirdness w/ rvm installing REE on lion
  # see: http://stackoverflow.com/questions/6170813/why-cant-i-install-rails-on-lion-using-rvm

  code <<-EOS
    source "#{user_path}.bash_profile"
    rvm remove #{default_ruby}
    export CC=/usr/bin/gcc-4.2
    rvm install --force #{default_ruby}
    rvm use #{default_gemset} --create
    rvm use #{default_gemset} --default
    gem update --system #{node[:rvm][:sbn_rubygems_version]}
    gem install bundler -v #{node[:rvm][:sbn_bundler_version]}
  EOS
  not_if <<-EOS
    source "#{user_path}.bash_profile"
    rvm list | grep #{default_ruby}
 EOS
  user node[:rvm][:user]
end


