#!/bin/bash

REPO_DIR="/var/chef-solo"
REPO_URL="http://github.com/clifff/sbn-chef-setup/tarball/master"

COOKBOOKS_DIR="$REPO_DIR/cookbooks-vendor"
COOKBOOKS_URL="http://github.com/josh/osx-cookbooks/tarball/master"

echo "Enter sudo password: "
read -s sudo_pass

# Install GCC
if which gcc >/dev/null; then
  echo "GCC already installed, skipping"
else
  curl -o -L https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg /tmp/gcc-install.pkg && sudo installer -pkg "/tmp/gcc-install.pkg" -target /
fi

echo ""
echo "Updating rubygems"
gem update --system

echo ""
echo "unpacking <http://github.com/clifff/sbn-chef-setup> into '$REPO_DIR'..."
echo $sudo_pass | sudo rm -Rf $REPO_DIR
echo $sudo_pass | sudo mkdir -p $REPO_DIR
echo $sudo_pass | sudo curl -sL $REPO_URL | sudo tar -xz -C $REPO_DIR -m --strip 1


echo "unpacking <http://github.com/josh/osx-cookbooks> into '$COOKBOOKS_DIR'..."
echo $sudo_pass | sudo rm -Rf $COOKBOOKS_DIR
echo $sudo_pass | sudo mkdir -p $COOKBOOKS_DIR
echo $sudo_pass | sudo curl -sL $COOKBOOKS_URL | sudo tar -xz -C $COOKBOOKS_DIR -m --strip 1

echo "running chef..."
echo ""

cd $REPO_DIR
echo $sudo_pass | sudo rake chef

echo ""
echo "installing sbn RVM gemset..."
rvm install ree-1.8.7-2010.02
rvm use ree-1.8.7-2010.02@sbn --create
rvm use ree-1.8.7-2010.02@sbn --default
gem update --system 1.3.7
gem install bundler -v 1.0.15

echo ""
echo "writing /etc/my.cnf copied from sbn repo..."
cat << 'EOF' > /etc/my.cnf
[mysqld]
character-set-server=utf8
collation-server=utf8_general_ci

[mysql]
default-character-set=utf8
EOF

echo ""
echo "installing various things via homebrew..."
brew install aspell --lang=en
brew install memcached
brew install redis
brew install ImageMagick
brew install libxml2 --with-xml2-config
brew link libxml2

echo ""
echo "installing mysql gem"
env ARCHFLAGS="-arch x86_64" gem install mysql -- --with-mysql-config=/usr/local/mysql/bin/mysql_config

echo ""
echo "Total victory!"
echo ""
