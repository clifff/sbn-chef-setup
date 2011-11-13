include_recipe "homebrew"

package "libxml2" do
  options "--with-xml2-config"
end

execute "brew link libxml2" do
  only_if { `which xml2-config`.index("/usr/local/bin").nil? }
end
