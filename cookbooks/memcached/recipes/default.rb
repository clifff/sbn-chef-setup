include_recipe "homebrew"

package "memcached"

if node[:memcached][:launchd]
  launch_service "com.danga.memcached" do
    path "#{ENV['HOME']}/Library/LaunchAgents/com.danga.memcached.plist"
  end
end
