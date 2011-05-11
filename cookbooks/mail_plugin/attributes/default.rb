default.mail_plugin[:user] = ENV['SUDO_USER'] || ENV['USER']
default.mail_plugin[:mail_bundles_path] = ::File.join(ENV['HOME'], 'Library', 'Mail', 'Bundles')

