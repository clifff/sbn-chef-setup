require 'chef/provider/service'
require 'shellwords'

class Chef::Provider::Service::Launch < Chef::Provider::Service
  PATHS = [
    "#{ENV['HOME']}/Library/LaunchAgents",
    "/Library/LaunchAgents",
    "/Library/LaunchDaemons",
    "/System/Library/LaunchAgents",
    "/System/Library/LaunchDaemons"
  ]

  def self.detect_path(label)
    PATHS.each do |path|
      file = ::File.join(path, "#{label}.plist")
      return file if ::File.exist?(file)
    end

    ::File.join(PATHS.first, "#{label}.plist")
  end

  def self.path_owned_by_root?(path)
    path =~ %r{^/System|^/Library}
  end

  attr_reader :init_command, :status_command
  attr_reader :current_resource

  def initialize(new_resource, run_context)
    super
    @init_command   = "launchctl"
    @status_command = "launchctl list"

    @user = run_context.node[:launch][:user]
  end

  def load_current_resource
    @current_resource = Chef::Resource::Service.new(new_resource.name)
    @current_resource.service_name(new_resource.service_name)
    @status = service_status.enabled
    @current_resource
  end

  def label
    new_resource.service_name
  end

  def path
    @path ||= self.class.detect_path(label)
  end

  def user
    self.class.path_owned_by_root?(path) ? "root" : @user
  end

  def action_reload
    Chef::Log.debug("#{@new_resource}: attempting to reload")
    if reload_service
      @new_resource.updated_by_last_action true
      Chef::Log.info("#{@new_resource}: reloaded successfully")
    end
  end

  def enable_service
    run_command(:command => "#{init_command} load -w -F #{path.shellescape}", :user => user)
    service_status.enabled
  end

  def disable_service
    run_command(:command => "#{init_command} unload -w -F #{path.shellescape}", :user => user)
    service_status.enabled
  end

  def start_service
    run_command(:command => "#{init_command} start #{label}", :user => user)
    service_status.running
  end

  def stop_service
    run_command(:command => "#{init_command} stop #{label}", :user => user)
    service_status.running
  end

  def restart_service
    stop_service if current_resource.running
    start_service
  end

  def reload_service
    disable_service if current_resource.enabled
    enable_service
  end

  def service_status
    status, stdout, stderr = output_of_command("#{status_command} | grep #{label}", :user => user)

    if status == 0
      pid = stdout.split(' ')[0]
    end

    case pid
    when nil, ''
      current_resource.enabled(false)
      current_resource.running(false)
    when '-'
      current_resource.enabled(true)
      current_resource.running(false)
    else
      current_resource.enabled(true)
      current_resource.running(true)
    end

    current_resource
  end
end

require 'chef/platform'
Chef::Platform.set :platform => :mac_os_x, :resource => :service, :provider => Chef::Provider::Service::Launch
