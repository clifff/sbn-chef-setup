include_recipe "homebrew"

# Unclear why ImageMagick requires me to pin down a version, but such is life
package "ImageMagick" do
  version "6.7.1-1"
end
