directory "/usr/local"

execute "install homebrew" do
  command %Q[/usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"]
  cwd "/usr/local"
  not_if { File.exist? '/usr/local/bin/brew' }
end

package 'git'

execute "update homebrew from github" do
  command "/usr/local/bin/brew update || true"
end
