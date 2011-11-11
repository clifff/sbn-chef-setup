DESCRIPTION
===========

Configures homebrew and homebrew packages. Branched from josh's homebrew recipe
because it excludes the brew-gem and brew-pip dependencies

RECIPES
=======

default
-------

The default recipe installs Homebrew at `homebrew[:prefix]` which defaults to `/usr/local`.

PROVIDERS
=========

Homebrew packages support `install`, `upgrade`, `remove` and `purge`.

`Chef::Provider::Package::Homebrew` is set to the default package manager on OS X.

    include_recipe "homebrew"

    package "git"

    package "node" do
      action :upgrade
    end
