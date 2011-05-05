#!/bin/bash


REPO_ROOT = "/tmp/chef-solo"
REPO_URL = "http://github.com/twelvelabs/osx-cookbooks/tarball/master"
VENDOR_COOKBOOKS_URL = "http://github.com/twelvelabs/osx-cookbooks/tarball/master"


# make sure chef is installed...
gem install chef --no-rdoc --no-ri

# unpack the repo into $REPO_ROOT...
rm -Rf $REPO_ROOT
mkdir -p $REPO_ROOT
curl -sL $REPO_URL | tar -xz -C $REPO_ROOT -m --strip 1
# unpack the vendor cookbooks
curl -sL $VENDOR_COOKBOOKS_URL | tar -xz -C "$REPO_ROOT/cookbooks-vendor" -m --strip 1

# get to cookin'...
sudo chef-solo -c "$REPO_ROOT/config/solo.rb" -j "$REPO_ROOT/config/node.json"