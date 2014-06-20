#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
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
include_recipe "mysql::client"

case node[:platform]
when "debian","ubuntu"

  directory "/var/cache/local/preseeding" do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end

  execute "preseed mysql-server" do
    command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
    action :nothing
  end

  template "/etc/mysql/debian.cnf" do
    source "debian.cnf.erb"
    owner "root"
    group "root"
    not_if "test -f /var/cache/local/preseeding/mysql-server.seed"
    mode "0600"
  end

  template "/var/cache/local/preseeding/mysql-server.seed" do
    source "mysql-server.seed.erb"
    owner "root"
    group "root"
    mode "0600"
    not_if "test -f /var/cache/local/preseeding/mysql-server.seed"
    notifies :run, resources(:execute => "preseed mysql-server"), :immediately
  end
when "redhat","centos"
  directory node[:mysql][:includedir] do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end
end

package "mysql-server" do
  if platform?("redhat","centos")
    package_name "mysql55-server"
  end
  action :install
end

directory "/var/lib/mysqltmp" do
  owner "mysql"
  group "mysql"
  mode 0755
  recursive true
end

service "mysql" do
  service_name value_for_platform([ "centos", "redhat", "suse", "fedora" ] => {"default" => "mysqld"}, "default" => "mysql")
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    restart_command "restart mysql"
    stop_command "stop mysql"
    start_command "start mysql"
    status_command "status mysql"
    reload_command "reload mysql"
  end
  supports :status => true, :restart => true, :reload => true
  action :enable
end

file "rm_ib_logfile0" do
  path "#{node[:mysql][:datadir]}/ib_logfile0"
  action :nothing
end

file "rm_ib_logfile1" do
  path "#{node[:mysql][:datadir]}/ib_logfile1"
  action :nothing
end

template value_for_platform([ "centos", "redhat", "suse" , "fedora" ] => {"default" => "/etc/my.cnf"}, "default" => "/etc/mysql/my.cnf") do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :delete, resources(:file => "rm_ib_logfile0"), :immediately
  notifies :delete, resources(:file => "rm_ib_logfile1"), :immediately
  notifies :restart, resources(:service => "mysql"), :immediately
end

unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

grants_path = value_for_platform(
  ["centos", "redhat", "suse", "fedora" ] => {
    "default" => "/etc/mysql_grants.sql"
  },
  "default" => "/etc/mysql/grants.sql"
)

begin
  t = resources(:template => grants_path)
rescue
  Chef::Log.warn("Could not find previously defined grants.sql resource")
  t = template grants_path do
    path grants_path
    source "grants.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    not_if "test -f #{grants_path}"
    action :create
  end
end

case node[:platform]
when "debian","ubuntu"
  execute "mysql-install-privileges" do
    command "/usr/bin/mysql -u root #{node[:mysql][:server_root_password].empty? ? '' : '-p' }#{node[:mysql][:server_root_password].shellescape} < #{grants_path}"
    action :nothing
    subscribes :run, resources(:template => grants_path), :immediately
  end
when "centos","redhat","suse","fedora"
  # No notion of preseeding in RPM distros.  Grant import will set password.
  execute "mysql-install-privileges" do
    command "/usr/bin/mysql -u root < #{grants_path}"
    action :nothing
    subscribes :run, resources(:template => grants_path), :immediately
  end
end

template "/root/.my.cnf" do
  source "dotmy.cnf.erb"
  owner "root"
  group "root"
  mode "0600"
  not_if "test -f /root/.my.cnf"
  variables :rootpasswd => node[:mysql][:server_root_password] 
end

template "/etc/logrotate.d/mysqllogs" do
  source "mysql-logrotate.erb"
  owner "mysql"
  group "mysql"
  mode "0644"
end

include_recipe "holland::mysqldump"
