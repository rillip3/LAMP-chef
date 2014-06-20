#
# Cookbook Name:: phpmyadmin
# Recipe:: default
#
# Copyright 2011, Rackspace Hosting
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

include_recipe "apache2"
include_recipe "mysql::client"
include_recipe "php5"

package node[:phpmyadmin][:name]

execute "phpmyadmin-htpasswd" do
  command "htpasswd -b -c /etc/#{node[:phpmyadmin][:name]}/phpmyadmin-htpasswd #{node[:phpmyadmin][:user]} #{node[:phpmyadmin][:pass].shellescape}"
  creates "/etc/#{node[:phpmyadmin][:name]}/phpmyadmin-htpasswd"
  action :run
end

template "/root/.phpmyadminpass" do
  source "phpmyadminpass.erb"
  mode 0400
  owner "root"
  group "root"
  not_if "test -f /root/.phpmyadminpass"
end

cookbook_file "/etc/#{node[:phpmyadmin][:name]}/apache.conf" do
  source "apache.conf"
  mode 0644
  owner "root"
  group "root"
end

template "/etc/#{node[:phpmyadmin][:name]}/config.inc.php" do
  source "config.inc.php.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "apache2")
end

case node[:platform]
  when "ubuntu","debian"
    package "php5-mcrypt"
    if node[:platform_version].to_f > 13.04
        execute("php5enmod mcrypt")
    end
    link "/etc/apache2/conf.d/phpmyadmin.conf" do
      to "/etc/phpmyadmin/apache.conf"
    end
  when "redhat","centos"
    link "/etc/httpd/conf.d/#{node[:phpmyadmin][:name]}.conf" do
      to "/etc/#{node[:phpmyadmin][:name]}/apache.conf"
    end
end
