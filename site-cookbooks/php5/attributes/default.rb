case platform
when "redhat","centos"
  set[:php][:ini] = "/etc/php.ini"
  default[:php][:packages] = [
    "php54",
    "php54-gd",
    "php54-mysql",
    "php54-pecl-apc",
    "php54-xml",
    "php54-devel"
  ]
when "ubuntu","debian"
  set[:php][:ini] = "/etc/php5/apache2/php.ini"
  default[:php][:packages] = [
    "libapache2-mod-php5",
    "php5-cli",
    "php-pear",
    "php5-mysql",
    "php-apc",
    "php5-gd",
    "php5-dev",
    "php5-curl"
  ]
end

# Resource Limits
default[:php][:max_execution_time] = "30"
default[:php][:memory_limit] = "16M"

# Error handling and logging
default[:php][:error_reporting] = "E_ALL & ~E_NOTICE | E_DEPRECATED"

# Data Handling
default[:php][:register_globals] = "Off"
default[:php][:post_max_size] = "8M"

# Language Options
default[:php][:short_open_tag] = "On"

# Paths and Directories
default[:php][:include_path] = ".:/usr/share/pear:/usr/share/php"

# File Uploads
default[:php][:upload_max_filesize] = "2M"

# Miscellaneous
default[:php][:expose_php] = "Off"

#Sessions
case platform
when "redhat","centos"
  default[:php][:session][:save_path] = "/var/lib/php/session"
when "ubuntu","debian"
  default[:php][:session][:save_path] = "/var/lib/php5/session"
end

# Dynamically set memory limit
case node[:memory][:total].to_i
when 450_000 .. 4_500_000  # 512M to 4G
  set[:php][:memory_limit] = "32M"
when 7_900_000 .. 31_000_000  # 8G+
  set[:php][:memory_limit] = "64M"
end
