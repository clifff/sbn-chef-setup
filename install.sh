#!/bin/bash

REPO_DIR="$HOME/chef-solo"
REPO_URL="http://github.com/clifff/sbn-chef-setup/tarball/master"

# Expire the sudo timer to make sure we read in a valid password
sudo -K

echo "Enter sudo password: "
read -s sudo_pass

# ensure the password is correct
if !(echo $sudo_pass | sudo -S pwd &> /dev/null); then
  echo "Incorrect sudo password! Please try again."
  exit
fi

# Install GCC, recause REE requires it
if [-f /usr/bin/gcc-4.2 ]; then
  echo "gcc-4.2 already installed, skipping"
else
  echo "Installing gcc-4.2..."
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
rake chef sudo_pass=$sudo_pass

# Abort unless we got a clean exit code from Chef
if [ $? -gt 0 ]; then
  echo "Something went wrong running Chef. Abort!"
  exit 1
fi

# We probably just wrote out the rvm loading stuff in .bash_profile so load it up
source $HOME/.bash_profile

echo ""
echo "installing mysql gem"
env ARCHFLAGS="-arch x86_64" gem install mysql --no-rdoc --no-ri -- --with-mysql-config=/usr/local/bin/mysql_config

# Abort unless we got a clean exit code from install mysql
if [ $? -gt 0 ]; then
  echo "Something went wrong installing the MySQL gem. Abort!"
  exit 1
fi

echo ""
echo "Total victory!"
echo "Three final things..."
echo "1) If everything went well, you can ignore all the Homebrew output above telling you to do things"
echo "2) Please run the command 'source ~/.bash_profile'"
echo "3) To continue SBN installation, head over to https://github.com/sbnation/sbn and continue following the directions there."
echo ""
