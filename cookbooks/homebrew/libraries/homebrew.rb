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
    status, stdout, stderr = output_of_command("#{brew_bin} list #{name} --versions", {:user => @user})
    status == 0 ? stdout.split(' ')[-1] : nil
  end

  def homebrew_candiate_version
    name = @new_resource.package_name
    status, stdout, stderr = output_of_command("#{brew_bin} info #{name} | head -n1", {:user => @user})
    status == 0 ? stdout.split(' ')[1] : nil
  end

  def install_package(name, version)
    options = expand_options(@new_resource.options)
    options += " --HEAD" if version == 'HEAD'
    run_brew_command "#{brew_bin} install #{name}#{options}"
  end

  def upgrade_package(name, version)
    install_package(name, version)
  end

  def remove_package(name, version)
    run_brew_command "#{brew_bin} unlink #{name}"
  end

  def purge_package(name, version)
    run_brew_command "#{brew_bin} uninstall #{name}"
  end

  def run_brew_command(command)
    run_command(:command => command, :user => @user)
  end
end

require 'chef/platform'
Chef::Platform.set :platform => :mac_os_x, :resource => :package, :provider => Chef::Provider::Package::Homebrew
