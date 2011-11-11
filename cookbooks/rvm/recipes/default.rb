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

# obiously only going to work for mac
load_string = "[[ -s \"/Users/#{node[:rvm][:user]}/./rvm/scripts/rvm\" ]] && source \"/Users/#{node[:rvm][:user]}/./rvm/scripts/rvm\""
bash_profile = '~/.bash_profile'
execute "echo \"#{load_string}\" 1> #{bash_profile}" do
  not_if { File.exist?(bash_profile) && IO.read(bash_profile).index(load_string) }
end

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
