#
# Cookbook Name:: nginx
# Provider:: conf
#
# Copyright 2013, Thomas Boerger
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

require "chef/dsl/include_recipe"
include Chef::DSL::IncludeRecipe

action :create do
  template ::File.join(node["nginx"]["confs_dir"], "#{new_resource.name}.conf") do
    cookbook new_resource.cookbook
    source new_resource.template

    mode 0644
    owner "root"
    group "root"

    variables(
      new_resource.variables
    )

    notifies :restart, "service[nginx]"
  end

  new_resource.updated_by_last_action(true)
end

action :delete do
  file ::File.join(node["nginx"]["confs_dir"], "#{new_resource.name}.conf") do
    action :delete
    notifies :restart, "service[nginx]"
  end

  new_resource.updated_by_last_action(true)
end
