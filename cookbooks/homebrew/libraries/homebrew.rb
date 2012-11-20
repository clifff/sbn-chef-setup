# Taken from https://github.com/josh/osx-cookbooks/blob/master/homebrew/libraries/homebrew.rb

require 'chef/provider/package'

class Chef::Provider::Package::Homebrew < ::Chef::Provider::Package
  def initialize(new_resource, run_context)
    super

    @user   = run_context.node[:homebrew][:user]
    @prefix = run_context.node[:homebrew][:prefix]
  end

  def brew_bin
    "#{@prefix}/bin/brew"
  end

  def load_current_resource
    @current_resource = Chef::Resource::HomebrewPackage.new(@new_resource.name)
    @current_resource.package_name(@new_resource.name)

    @current_resource.version(current_installed_version)
    Chef::Log.debug("Current version is #{@current_resource.version}") if @current_resource.version

    if @current_resource.version == 'HEAD'
      @candidate_version = 'HEAD'
    else
      @candidate_version = homebrew_candiate_version
    end

    if !@new_resource.version && !@candidate_version
      raise Chef::Exceptions::Package, "Could not get a candidate version for this package -- #{@new_resource.name} does not seem to be a valid package!"
    end

    Chef::Log.debug("Homebrew candidate version is #{@candidate_version}")

    @current_resource
  end

  def current_installed_version
    name = @new_resource.package_name
    name = ::File.basename(name, '.rb') if name =~ /https?:\/\//
    status, stdout, stderr = output_of_brew_command("list #{name} --versions")
    status == 0 ? stdout.split(' ')[-1] : nil
  end

  def homebrew_candiate_version
    brew_update
    name = @new_resource.package_name
    status, stdout, stderr = output_of_brew_command("info #{name} | head -n1")
    # sample output: "<name>: stable <version>, HEAD"
    status == 0 ? stdout.split(' ')[2].chomp(',') : nil
  end

  def output_of_brew_command(command)
    output_of_command "#{brew_bin} #{command}", :user => @user, :cwd => @prefix
  end

  def install_package(name, version)
    options = expand_options(@new_resource.options)
    options += " --HEAD" if version == 'HEAD'
    run_brew_command "install #{name}#{options}"
  end

  def upgrade_package(name, version)
    options = expand_options(@new_resource.options)
    options += " --HEAD" if version == 'HEAD'
    run_brew_command "upgrade #{name}#{options}"
  end

  def remove_package(name, version)
    run_brew_command "unlink #{name}"
  end

  def purge_package(name, version)
    run_brew_command "uninstall #{name}"
  end

  def brew_update
    return if defined? @@brew_update_ran
    run_brew_command "update"
    @@brew_update_ran = true
  end

  def run_brew_command(command)
    run_command :command => "#{brew_bin} #{command}", :user => @user, :cwd => @prefix
  end
end

require 'chef/platform'
Chef::Platform.set :platform => :mac_os_x, :resource => :package, :provider => Chef::Provider::Package::Homebrew
