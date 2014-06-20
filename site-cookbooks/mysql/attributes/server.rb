#
# Cookbook Name:: mysql
# Attributes:: server
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

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

set_unless[:mysql][:server_debian_password] = secure_password
set_unless[:mysql][:server_root_password] = secure_password
set_unless[:mysql][:server_repl_password] = secure_password
default[:mysql][:datadir]              = "/var/lib/mysql"
default[:mysql][:log_slow]             = "/var/lib/mysql/slow-log"
default[:mysql][:log_bin]              = "/var/lib/mysql/bin-log"
default[:mysql][:log_relay]              = "/var/lib/mysql/relay-log"

case node[:platform]
  when "redhat","centos"
    default[:mysql][:includedir]	= "/etc/sysconfig/mysqld-config/"
    default[:mysql][:socket]		= "/var/lib/mysql/mysql.sock"
    default[:mysql][:log_error]		= "/var/log/mysqld.log"
  when "ubuntu","debian"
    default[:mysql][:includedir]	= "/etc/mysql/conf.d/"
    default[:mysql][:socket]		= "/var/run/mysqld/mysqld.sock"
    default[:mysql][:log_error]		= "/var/log/mysql/error.log"
end

if attribute?(:ec2)
  default[:mysql][:ec2_path]    = "/mnt/mysql"
  default[:mysql][:ebs_vol_dev] = "/dev/sdi"
  default[:mysql][:ebs_vol_size] = 50
end

# Tunables
default[:mysql][:tunable][:wait_timeout]            = "180"
default[:mysql][:tunable][:net_read_timeout]        = "30"
default[:mysql][:tunable][:net_write_timeout]       = "30"
default[:mysql][:tunable][:back_log]                = "128"
default[:mysql][:tunable][:table_open_cache]        = "2048"
default[:mysql][:tunable][:max_heap_table_size]     = "64M"
default[:mysql][:tunable][:query_cache_size]        = "32M"
default[:mysql][:tunable][:max_connections]         = "500"
if node[:hostname] =~ /(^|-)db(-|[\d]{1,2})?/
  default[:mysql][:tunable][:key_buffer_size]         = "#{(node[:memory][:total].to_i * 0.25 / 1024).to_i}M"
  default[:mysql][:tunable][:innodb_log_buffer_size] = "8M"
  default[:mysql][:tunable][:innodb_buffer_pool_size] = "#{(node[:memory][:total].to_i * 0.6 / 1024).to_i}M"
else
  default[:mysql][:tunable][:key_buffer_size]         = "64M"
  default[:mysql][:tunable][:innodb_log_buffer_size] = "4M"
  default[:mysql][:tunable][:innodb_buffer_pool_size] = "#{(node[:memory][:total].to_i * 0.0825 / 1024).to_i}M"
end
  
case node[:memory][:total].to_i
when 200000 .. 300000
  set[:mysql][:tunable][:max_connections]        = "25"
  set[:mysql][:tunable][:query_cache_size]       = "4M"
  set[:mysql][:tunable][:max_heap_table_size]    = "16M"
when 450000 .. 600000
  set[:mysql][:tunable][:max_connections]        = "50"
when 900000 .. 1500000
  set[:mysql][:tunable][:max_connections]        = "75"
when 1900000 .. 2500000
  set[:mysql][:tunable][:max_connections]        = "100"
when 3900000 .. 4500000
  set[:mysql][:tunable][:max_connections]        = "200"
when 7900000 .. 8500000
  set[:mysql][:tunable][:max_connections]        = "300"
when 14000000 .. 17000000
  set[:mysql][:tunable][:max_connections]        = "400"
when 28000000 .. 31000000
  set[:mysql][:tunable][:max_connections]        = "500"
end
