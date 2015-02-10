#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013-2014, Thomas Boerger <thomas@webhippie.de>
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

case node["platform_family"]
when "suse"
  include_recipe "zypper"

  zypper_repository node["nginx"]["zypper"]["alias"] do
    uri node["nginx"]["zypper"]["repo"]
    key node["nginx"]["zypper"]["key"]
    title node["nginx"]["zypper"]["title"]

    action :add

    only_if do
      node["nginx"]["zypper"]["enabled"]
    end
  end
end

node["nginx"]["packages"].each do |name|
  package name do
    action :install
  end
end

node["nginx"]["removed_files"].each do |name|
  file name do
    action :delete

    only_if do
      File.exists? name
    end
  end
end

node["nginx"]["removed_links"].each do |name|
  link name do
    action :delete

    only_if do
      File.symlink? name
    end
  end
end

node["nginx"]["removed_dirs"].each do |name|
  directory name do
    action :delete
    recursive true

    only_if do
      File.directory? name
    end
  end
end

[
  node["nginx"]["confs_dir"],
  node["nginx"]["apps_dir"]
].each do |name|
  directory name do
    owner "root"
    group "root"
    mode 0755
  end
end

directory node["nginx"]["web_dir"] do
  owner node["nginx"]["user"]
  group node["nginx"]["group"]
  mode 0755
end

node["nginx"]["page_files"].each do |name|
  template ::File.join(node["nginx"]["web_dir"], name) do
    source "pages/#{name}.erb"
    owner node["nginx"]["user"]
    group node["nginx"]["group"]
    mode 0644

    variables(
      node["nginx"]
    )
  end
end

node["nginx"]["config_files"].each do |name|
  template ::File.join(node["nginx"]["config_dir"], name) do
    source "#{name}.erb"
    owner "root"
    group "root"
    mode 0644

    variables(
      node["nginx"]
    )

    notifies :restart, "service[nginx]"
  end
end

node["nginx"]["confs"].each do |name|
  nginx_conf name do
    template "confs/#{name}.conf.erb"
    variables node["nginx"]

    action :create
  end
end

node["nginx"]["apps"].each do |name|
  nginx_app name do
    template "apps/#{name}.conf.erb"
    variables node["nginx"]

    action :create
  end
end

service "nginx" do
  service_name node["nginx"]["service_name"]
  action [:enable, :start]
end
