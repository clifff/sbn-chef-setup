sudo "create /usr/local" do
  command "mkdir /usr/local"
  not_if { File.directory?('/usr/local') }
end

execute "install homebrew" do
  command %Q[/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"]
  cwd "/usr/local"
  not_if { File.exist? '/usr/local/bin/brew' }
end

package 'git'

execute "update homebrew from github" do
  command "/usr/local/bin/brew update || true"
end
