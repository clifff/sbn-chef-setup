#
# Cookbook Name:: mail_plugin
# Recipe:: letterbox
#
# Copyright 2011, Skip Baney
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'shellwords'

bundle_name = "Letterbox.mailbundle"
file_cache_path = Chef::Config[:file_cache_path]

archive_path = ::File.join(file_cache_path, "#{bundle_name}.tar.gz")
extracted_path = ::File.join(file_cache_path, "#{bundle_name}")

dest_path = "#{node[:mail_plugin][:mail_bundles_path]}/#{bundle_name}"

unless ::File.exist?(dest_path)
  # download and unpack...
  remote_file archive_path do
    source "http://dl.dropbox.com/u/15755878/chef-files/#{bundle_name}.tar.gz"
  end
  archive archive_path do
    not_if { ::File.exist?(extracted_path) }
    action :extract
  end

  # copy over to destination
  execute "ditto #{extracted_path.shellescape} #{dest_path}" do
    user node[:mail_plugin][:user]
    group 'staff'
    creates dest_path
  end

  # cleanup
  file archive_path do
    action :delete
  end
  directory extracted_path do
    recursive true
    action :delete
  end
end


