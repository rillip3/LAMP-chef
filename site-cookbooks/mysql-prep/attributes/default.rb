#IUS
case node[:platform_version]
  when /^6/
    set[:mysql_prep][:ius] = "ius-release-1.0-8.ius.el6.noarch.rpm"
end

#MySQL
default['mysql_prep']['mysql']['datadir'] = "/var/lib/mysql"
default['mysql_prep']['mysql']['log_slow'] = "/var/lib/mysql/slow-log"
default['mysql_prep']['mysql']['log_bin'] = "/var/lib/mysql/bin-log"
default['mysql_prep']['mysql']['log_relay'] = "/var/lib/mysql/relay-log"

case node['platform']
  when "redhat","centos"
    default['mysql_prep']['mysql']['includedir']    = "/etc/sysconfig/mysqld-config/"
    default['mysql_prep']['mysql']['socket']    = "/var/lib/mysql/mysql.sock"
    default['mysql_prep']['mysql']['log_error'] = "/var/log/mysqld.log"
  when "ubuntu","debian"
    default['mysql_prep']['mysql']['includedir']    = "/etc/mysql/conf.d/"
    default['mysql_prep']['mysql']['socket']    = "/var/run/mysqld/mysqld.sock"
    default['mysql_prep']['mysql']['log_error'] = "/var/log/mysql/error.log"
end

# Tunables
default['mysql_prep']['mysql']['tunable']['wait_timeout'] = "180"
default['mysql_prep']['mysql']['tunable']['net_read_timeout'] = "30"
default['mysql_prep']['mysql']['tunable']['net_write_timeout'] = "30"
default['mysql_prep']['mysql']['tunable']['back_log'] = "128"
default['mysql_prep']['mysql']['tunable']['table_open_cache'] = "2048"
default['mysql_prep']['mysql']['tunable']['max_heap_table_size'] = "64M"
default['mysql_prep']['mysql']['tunable']['query_cache_size'] = "32M"
default['mysql_prep']['mysql']['tunable']['max_connections'] = "500"
if node['hostname'] =~ /(^|-)db(-|[\d']{1,2})?/
  default['mysql_prep']['mysql']['tunable']['key_buffer_size'] = "#{(node['memory']['total'].to_i * 0.25 / 1024).to_i}M"
  default['mysql_prep']['mysql']['tunable']['innodb_log_buffer_size'] = "8M"
  default['mysql_prep']['mysql']['tunable']['innodb_buffer_pool_size'] = "#{(node['memory']['total'].to_i * 0.6 / 1024).to_i}M"
else
  default['mysql_prep']['mysql']['tunable']['key_buffer_size'] = "64M"
  default['mysql_prep']['mysql']['tunable']['innodb_log_buffer_size'] = "4M"
  default['mysql_prep']['mysql']['tunable']['innodb_buffer_pool_size'] = "#{(node['memory']['total'].to_i * 0.0825 / 1024).to_i}M"
end
  
case node['memory']['total'].to_i
when 200000 .. 300000
  set['mysql_prep']['mysql']['tunable']['max_connections'] = "25"
  set['mysql_prep']['mysql']['tunable']['query_cache_size'] = "4M"
  set['mysql_prep']['mysql']['tunable']['max_heap_table_size'] = "16M"
when 450000 .. 600000
  set['mysql_prep']['mysql']['tunable']['max_connections'] = "50"
when 900000 .. 1500000
  set['mysql_prep']['mysql']['tunable']['max_connections'] = "75"
when 1900000 .. 2500000
  set['mysql_prep']['mysql']['tunable']['max_connections'] = "100"
when 3900000 .. 4500000
  set['mysql_prep']['mysql']['tunable']['max_connections'] = "200"
when 7900000 .. 8500000
  set['mysql_prep']['mysql']['tunable']['max_connections'] = "300"
when 14000000 .. 17000000
  set['mysql_prep']['mysql']['tunable']['max_connections'] = "400"
when 28000000 .. 31000000
  set['mysql_prep']['mysql']['tunable']['max_connections'] = "500"
end
