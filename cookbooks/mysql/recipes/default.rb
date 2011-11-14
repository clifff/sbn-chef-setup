include_recipe "homebrew"

package "mysql"

# Hopefully there is no problem with this always running?
execute "mysql_install_db" do
  install_db = %Q[mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp]
  command install_db
  user node[:homebrew][:user]
end

# Would be nice to have this as a template, but it needs to be run as sudo and chef is called as a normal user
template "/etc/my.cnf" do
  source "my.cnf"
  owner root
  mode "777"
  not_if { File.exists?("/etc/mf.cnf") }
end

if node[:mysql][:launchd]
  launch_service "com.mysql.mysqld" do
    template_variables :prefix => node[:homebrew][:prefix]
  end
end
