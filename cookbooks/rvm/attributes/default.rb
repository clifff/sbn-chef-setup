default.rvm[:user]   = ENV['SUDO_USER'] || ENV['USER']
default.rvm[:prefix] = "#{ENV['HOME']}/."
default.rvm[:default_gemset] = "ree-1.8.7-2010.02@sbn"
default.rvm[:sbn_rubygems_version] = "1.3.7"
default.rvm[:sbn_bundler_version] = "1.0.15"
