include_recipe "homebrew"

package "libxml2" do
  options "--with-xml2-config"
end

execute "brew link libxml2" do
  # Ignore failure cause I dont understand this requirement in the first place
  ignore_failure true
end
