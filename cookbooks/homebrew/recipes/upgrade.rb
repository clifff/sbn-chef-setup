include_recipe "homebrew"

`#{node[:homebrew][:prefix]}/bin/brew outdated`.lines.each do |line|
  package line.chomp do
    action :upgrade
    notifies :run, resources(:execute => "brew cleanup"), :delayed
  end
end
