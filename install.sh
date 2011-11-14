#!/bin/bash

REPO_DIR="$HOME/chef-solo"
REPO_URL="http://github.com/clifff/sbn-chef-setup/tarball/master"

echo "Enter sudo password: "
read -s sudo_pass

# Install GCC, but only if it doesnt exist
if which gcc >/dev/null; then
  echo "GCC already installed, skipping"
else
  echo "Installing GCC..."
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

# We probably just wrote out the rvm loading stuff in .bash_profile so load it up
source $HOME/.bash_profile

# TODO: Move this into chef template
echo ""
echo "writing /etc/my.cnf copied from sbn repo..."
echo $sudo_pass | sudo -S bash -c "cat << 'EOF' > /etc/my.cnf
[mysqld]
character-set-server=utf8
collation-server=utf8_general_ci

[mysql]
default-character-set=utf8
EOF
"
echo ""
echo "installing mysql gem"
env ARCHFLAGS="-arch x86_64" gem install mysql -- --with-mysql-config=/usr/local/bin/mysql_config

echo ""
echo "Total victory!"
echo "Two final things..."
echo "1) Please run the command 'source ~/.bash_profile'"
echo "2) To continue SBN installation, head over to https://github.com/sbnation/sbn and continue following the directions there."
echo ""
