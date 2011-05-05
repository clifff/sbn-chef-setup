#!/bin/bash


TMP_DIR="/tmp/chef-solo"
REPO_URL="http://github.com/twelvelabs/chef-repo/tarball/master"

# unpack the repo into $REPO_ROOT...
rm -Rf $TMP_DIR
mkdir -p $TMP_DIR
curl -sL $REPO_URL | tar -xz -C $TMP_DIR -m --strip 1

# get to cookin'...
cd $TMP_DIR && rake chef