# SBN Dependency Installer

## Introduction
The purpose of this script to install all the neccesary dependices such
that Vox Media developers/designers/etc can go from a clean OS X install to a
running SBN app as fast and simply as possible.

Note that right now, this script only supports Lion (OS X 10.7), and
is only designed to work on a totally clean installation.

## How to use

1. Open up the App Store and [download/install the latest version of Xcode.](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)

2. [Go to this page and download/install "Command Line Tools for Xcode"](https://developer.apple.com/downloads/index.action).
You may have to register/sign in, so go ahead and do that.

3. Agree to Xcode's licensing agreement by running:

<!-- break list -->

    xcodebuild -license

4. Run this (all one line) in a terminal. At the start, it will ask you for an administrator password and (might) have you click through the installer for GCC, but after that it should chug along unattendend.

<!-- force end of numbered list before code black -->

    curl -L https://raw.github.com/clifff/sbn-chef-setup/master/install.sh -o /tmp/sbn_install.sh && chmod +x /tmp/sbn_install.sh && /tmp/sbn_install.sh

## Technical Details
In short, this script uses Chef-solo (contained inthis repo) to manage Homebrew packages and other dependencies used by the SBN app. The install process roughly goes like this:

* Updates rubygems (so that Chef can be installed cleanly)
* Copies this repo and unzips it
* Installs the chef gem
* Chef installs homebrew and uses that as it's package manger
* Chef installs:
  * git
  * rvm (and installs SBN's gemset/ruby version)
  * memcached
  * redis
  * aspell
  * ImageMagick
  * mysql
  * nginx
* Finally, it installs the mysql gem into the SBN gemset
