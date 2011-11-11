#!/bin/bash

REPO_DIR="/tmp/chef-solo"
REPO_URL="http://github.com/clifff/sbn-chef-setup/tarball/master"

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
rm -Rf $REPO_DIR
mkdir -p $REPO_DIR
curl -sL $REPO_URL | tar -xz -C $REPO_DIR -m --strip 1

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
