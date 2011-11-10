#!/bin/bash


REPO_DIR="/var/chef-solo"
REPO_URL="http://github.com/twelvelabs/chef-repo/tarball/master"

COOKBOOKS_DIR="$REPO_DIR/cookbooks-vendor"
COOKBOOKS_URL="http://github.com/twelvelabs/osx-cookbooks/tarball/master"


echo ""
echo "unpacking <http://github.com/twelvelabs/chef-repo> into '$REPO_DIR'..."
rm -Rf $REPO_DIR
mkdir -p $REPO_DIR
curl -sL $REPO_URL | tar -xz -C $REPO_DIR -m --strip 1


echo "unpacking <http://github.com/twelvelabs/osx-cookbooks> into '$COOKBOOKS_DIR'..."
rm -Rf $COOKBOOKS_DIR
mkdir -p $COOKBOOKS_DIR
curl -sL $COOKBOOKS_URL | tar -xz -C $COOKBOOKS_DIR -m --strip 1

echo "running chef..."
echo ""

cd $REPO_DIR
rake chef

echo ""
echo "installing sbn RVM gemset..."
rvm install ree-1.8.7-2010.02
rvm use ree-1.8.7-2010.02@sbn --create
rvm use ree-1.8.7-2010.02@sbn --default
gem update --system 1.3.7
gem install bundler -v 1.0.15

# TODO mysql my.cnf stuff here
# TODO git name/email

echo ""
echo "installing various things via homebrew..."
brew install aspell --lang=en
brew install memcached
brew install redis
brew install ImageMagick
brew install libxml2 --with-xml2-config
brew link libxml2
end

echo "installing mysql gem"
env ARCHFLAGS="-arch x86_64" gem install mysql -- --with-mysql-config=/usr/local/mysql/bin/mysql_config

echo ""
echo "fini!"
echo ""
