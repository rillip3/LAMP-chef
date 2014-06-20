maintainer       "Rackspace Hosting"
maintainer_email "mcops@lists.rackspace.com"
license          "All rights reserved"
description      "Provides tuned files for MySQL"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
name             "mysql-prep"
version          "0.0.1"
depends          "mysql"
attribute "mysql_prep/mysql/includedir",
  :display_name => "MySQL include dir",
  :description => "Directory to add to the include line",
  :type => "string",
  :default => "/etc/sysconfig/mysqld-config/"
attribute "mysql_prep/mysql/socket",
  :display_name => "MySQL config file",
  :description => "File to set as the mysql config",
  :type => "string",
  :default => "/var/lib/mysql/mysql.sock"
attribute "mysql_prep/mysql/log_error",
  :display_name => "Error log",
  :description => "Location of the error log",
  :type => "string",
  :default => "/var/log/mysqld.log"
attribute "mysql_prep/mysql/tunable/wait_timeout",
  :display_name => "Wait Timeout",
  :description => "Delay before connection closed for wait",
  :type => "string",
  :default => "180"
attribute "mysql_prep/mysql/tunable/net_read_timeout",
  :display_name => "Net Read Timeout",
  :description => "Delay before connection close for net traffic reads",
  :type => "string",
  :default => "30"
attribute "mysql_prep/mysql/tunable/net_write_timeout",
  :display_name => "Net Write Timeout",
  :description => "Delay before connection close for net traffic writes",
  :type => "string",
  :default => "30"
attribute "mysql_prep/mysql/tunable/back_log",
  :display_name => "Back Log",
  :description => "Back log setting",
  :type => "string",
  :default => "128"
attribute "mysql_prep/mysql/tunable/table_open_cache",
  :display_name => "Open Cache tables",
  :description => "Number of open cachce tables",
  :type => "string",
  :default => "2048"
attribute "mysql_prep/mysql/tunable/max_heap_table_size",
  :display_name => "Max Heap table size",
  :description => "Maximum size of the heap table",
  :type => "string",
  :default => "64M"
attribute "mysql_prep/mysql/tunable/query_cache_size",
  :display_name => "Query cache size",
  :description => "Size query cache",
  :type => "string",
  :default => "32M"
attribute "mysql_prep/mysql/tunable/max_connections",
  :display_name => "Max Connections",
  :description => "Maximum number of simultaneous connections",
  :type => "string",
  :default => "500"
attribute "mysql_prep/mysql/tunable/key_buffer_size",
  :display_name => "Key buffer size",
  :description => "Size of key buffers",
  :type => "string",
  :default => "8M"
attribute "mysql_prep/mysql/tunable/innodb_log_buffer_size",
  :display_name => "InnoDB log buffer size",
  :description => "Size of the InnoDB log buffer",
  :type => "string",
  :default => "8M"
attribute "mysql_prep/mysql/tunable/innodb_buffer_pool_size",
  :display_name => "InnoDB Buffer Pool Size",
  :description => "Size of InnoDB Buffer Pool",
  :type => "string",
  :default => "8M" 
attribute "mysql_prep/ius",
  :display_name => "IUS repo",
  :description => "URL for IUS",
  :type => "string",
  :default => "ius-release-1.0-8.ius.el6.noarch.rpm" 
