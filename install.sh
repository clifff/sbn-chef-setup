#!/bin/bash


REPO_DIR="/var/chef-solo"
REPO_URL="http://github.com/twelvelabs/chef-repo/tarball/master"

COOKBOOKS_DIR="$REPO_DIR/cookbooks-vendor"
COOKBOOKS_URL="http://github.com/twelvelabs/osx-cookbooks/tarball/master"


# unpack the repo into $REPO_DIR...
rm -Rf $REPO_DIR
mkdir -p $REPO_DIR
curl -sL $REPO_URL | tar -xz -C $REPO_DIR -m --strip 1

# unpack the third party cookbooks
rm -Rf $COOKBOOKS_DIR
mkdir -p $COOKBOOKS_DIR
curl -sL $COOKBOOKS_URL | tar -xz -C $COOKBOOKS_DIR -m --strip 1

# get to cookin'...
cd $REPO_DIR && rake chef
