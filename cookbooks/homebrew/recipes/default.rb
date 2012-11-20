sudo "create /usr/local" do
  command "mkdir /usr/local"
  not_if { File.directory?('/usr/local') }
end

execute "install homebrew" do
  command %Q[/usr/bin/ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"]
  cwd "/usr/local"
  not_if { File.exist? '/usr/local/bin/brew' }
end

execute "update homebrew from github" do
  command "/usr/local/bin/brew update || true"
end

tap_source = "homebrew/dupes"
execute "add dupes sources" do
  command "/usr/local/bin/brew tap #{tap_source}"
  not_if { `/usr/local/bin/brew tap`.include?(tap_source) }
end

# These are all neccesary to get gcc 4.2, which rvm needs to install things and
# XCode no longer includes by default
package "autoconf"
package "automake"
package "apple-gcc42"
