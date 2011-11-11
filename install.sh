#!/bin/bash

REPO_DIR="/var/chef-solo"
REPO_URL="http://github.com/clifff/sbn-chef-setup/tarball/master"

COOKBOOKS_DIR="$REPO_DIR/cookbooks-vendor"
COOKBOOKS_URL="http://github.com/twelvelabs/osx-cookbooks/tarball/master"

echo "Enter sudo password: "
read -s sudo_pass

# Install GCC, but only if it doesnt exist
if which gcc >/dev/null; then
  echo "GCC already installed, skipping"
else
  curl -L https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg -o /tmp/gcc-install.pkg
  echo $sudo_pass | sudo -S installer -pkg "/tmp/gcc-install.pkg" -target /
fi

echo ""
echo "Updating rubygems"
if which rvm >/dev/null; then
  gem update --system
else
  echo $sudo_pass | sudo -S gem update --system
fi

echo ""
echo "unpacking <http://github.com/clifff/sbn-chef-setup> into '$REPO_DIR'..."
echo $sudo_pass | sudo -S rm -Rf $REPO_DIR
echo $sudo_pass | sudo -S mkdir -p $REPO_DIR
echo $sudo_pass | sudo -S curl -sL $REPO_URL | sudo tar -xz -C $REPO_DIR -m --strip 1


echo "unpacking <http://github.com/twelvelabs/osx-cookbooks> into '$COOKBOOKS_DIR'..."
echo $sudo_pass | sudo -S rm -Rf $COOKBOOKS_DIR
echo $sudo_pass | sudo -S mkdir -p $COOKBOOKS_DIR
echo $sudo_pass | sudo -S curl -sL $COOKBOOKS_URL | sudo tar -xz -C $COOKBOOKS_DIR -m --strip 1

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
