include_recipe "homebrew"

package "mysql"

execute "mysql_install_db" do
  command "mysql_install_db  --user=mysql --tmpdir=/tmp && mysql.server start && mysql_secure_installation"
  user node[:homebrew][:user]
  creates "#{node[:homebrew][:prefix]}/var/mysql"
end

if node[:mysql][:launchd]
  launch_service "com.mysql.mysqld" do
    template_variables :prefix => node[:homebrew][:prefix]
  end
end
