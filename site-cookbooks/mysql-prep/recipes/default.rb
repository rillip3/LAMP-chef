# coding: utf-8
#
# Cookbook Name:: mysql_prep
# Recipe:: node.set
#
# Copyright 2014
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# remove the ib_log files so we can restart mysql with the new settings
# based on size
include_recipe "mysql::server"

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
  path "#{node[:mysql_prep][:mysql][:datadir]}/ib_logfile0"
  action :nothing
end

file "rm_ib_logfile1" do
  path "#{node[:mysql_prep][:mysql][:datadir]}/ib_logfile1"
  action :nothing
end

template value_for_platform([ "centos", "redhat", "suse" , "fedora" ] => {"default" => "/etc/my.cnf"}, "default" => "/etc/mysql/my.cnf") do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
    :datadir => node[:mysql_prep][:mysql][:datadir],
    :socket => node[:mysql_prep][:mysql][:socket],
    :log_error => node[:mysql_prep][:mysql][:log_error],
    :table_open_cache => node[:mysql_prep][:mysql][:tunable][:table_open_cache],
    :query_cache_size => node[:mysql_prep][:mysql][:tunable][:query_cache_size],
    :max_heap_table_size => node[:mysql_prep][:mysql][:tunable][:max_heap_table_size],
    :max_connections => node[:mysql_prep][:mysql][:tunable][:max_connections],
    :wait_timeout => node[:mysql_prep][:mysql][:tunable][:wait_timeout],
    :net_read_timeout => node[:mysql_prep][:mysql][:tunable][:net_read_timeout],
    :net_write_timeout => node[:mysql_prep][:mysql][:tunable][:net_writee_timeout],
    :back_log => node[:mysql_prep][:mysql][:tunable][:back_log],
    :key_buffer_size => node[:mysql_prep][:mysql][:tunable][:key_buffer_size],
    :innodb_buffer_pool_size => node[:mysql_prep][:mysql][:tunable][:innodb_buffer_pool_size],
    :innodb_log_buffer_size => node[:mysql_prep][:mysql][:tunable][:innodb_log_buffer_size],
    :log_bin => node[:mysql_prep][:mysql][:log_bin],
    :log_relay => node[:mysql_prep][:mysql][:log_relay],
    :log_slow => node[:mysql_prep][:mysql][:log_slow],
    :log_error => node[:mysql_prep][:mysql][:log_error],
    :includedir => node[:mysql_prep][:mysql][:includedir]
  }) 
  notifies :delete, resources(:file => "rm_ib_logfile0"), :immediately
  notifies :delete, resources(:file => "rm_ib_logfile1"), :immediately
  notifies :restart, resources(:service => "mysql"), :delayed
end
