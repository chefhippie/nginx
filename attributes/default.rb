#
# Cookbook Name:: nginx
# Attributes:: default
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

default["nginx"]["packages"] = value_for_platform_family(
  "debian" => %w(
    nginx
  ),
  "suse" => %w(
    nginx
  )
)

default["nginx"]["web_dir"] = value_for_platform_family(
  "debian" => "/var/www",
  "suse" => "/srv/www/htdocs"
)

default["nginx"]["user"] = value_for_platform_family(
  "debian" => "www-data",
  "suse" => "nginx"
)

default["nginx"]["group"] = value_for_platform_family(
  "debian" => "www-data",
  "suse" => "nginx"
)

default["nginx"]["apps"] = %w(
  default
)

default["nginx"]["confs"] = %w(
  default
)

default["nginx"]["removed_files"] = %w(
  /etc/nginx/fastcgi.conf
  /etc/nginx/fastcgi.conf.default
  /etc/nginx/koi-utf
  /etc/nginx/koi-win
  /etc/nginx/win-utf
  /etc/nginx/uwsgi_params
  /etc/nginx/uwsgi_params.default
  /etc/nginx/scgi_params
  /etc/nginx/scgi_params.default
  /etc/nginx/fastcgi_params
  /etc/nginx/fastcgi_params.default
  /etc/nginx/proxy_params
  /etc/nginx/naxsi_core.rules
  /etc/nginx/naxsi.rules
  /etc/nginx/mime.types.default
  /etc/nginx/nginx.conf.default
  /etc/nginx/sites-available/default
)

default["nginx"]["removed_links"] = %w(

)

default["nginx"]["removed_dirs"] = %w(
  /etc/nginx/sites-enabled
)

default["nginx"]["config_files"] = %w(
  nginx.conf
  mime.types
  fastcgi.params
  scgi.params
  uwsgi.params
  proxy.params
)

default["nginx"]["page_files"] = %w(
  index.html
  404.html
  50x.html
)

default["nginx"]["service_name"] = "nginx"
default["nginx"]["config_dir"] = "/etc/nginx"
default["nginx"]["confs_dir"] = "/etc/nginx/conf.d"
default["nginx"]["apps_dir"] = "/etc/nginx/sites-available"
default["nginx"]["listen"] = "0.0.0.0"
default["nginx"]["processes"] = 3
default["nginx"]["connections"] = 1024

default["nginx"]["ssl"]["enabled"] = false
default["nginx"]["ssl"]["key"] = ""
default["nginx"]["ssl"]["cert"] = ""

default["nginx"]["zypper"]["enabled"] = true
default["nginx"]["zypper"]["alias"] = "server-http"
default["nginx"]["zypper"]["title"] = "Server HTTP"
default["nginx"]["zypper"]["repo"] = "http://download.opensuse.org/repositories/server:/http/openSUSE_#{node["platform_version"] == "12.1" ? "12.3" : node["platform_version"]}/"
default["nginx"]["zypper"]["key"] = "#{node["nginx"]["zypper"]["repo"]}repodata/repomd.xml.key"
