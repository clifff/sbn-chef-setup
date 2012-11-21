include_recipe "dmg"

dmg_package "mysql" do
  dmg_name "googlechrome"
  source "http://downloads.mysql.com/archives/mysql-5.1/mysql-5.1.62-osx10.6-x86_64.dmg"
  action :install
end

# Hopefully there is no problem with this always running?
execute "mysql_install_db" do
  install_db = %Q[mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp]
  command install_db
  user node[:homebrew][:user]
end

# Would be nice to have this as a template, but it needs to be run as sudo and chef is called as a normal user
sudo "populate /etc/my.cnf" do
  templates_path = File.expand_path(File.join(File.dirname(__FILE__), "..", "templates"))
  command "cp #{templates_path}/default/my.cnf /etc/my.cnf"
  not_if { File.exists?("/etc/my.cnf") }
end

if node[:mysql][:launchd]
  launch_service "com.mysql.mysqld" do
    template_variables :prefix => node[:homebrew][:prefix]
  end
end
