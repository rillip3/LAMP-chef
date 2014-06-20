::Chef::Node.send(:include, Opscode::OpenSSL::Password)
# Apache
# Where the various parts of apache are
case platform
when "redhat","centos","fedora","suse"
  set[:apache][:package] = "httpd"
  set[:apache][:dir] = "/etc/httpd"
  set[:apache][:log_dir] = "/var/log/httpd"
  set[:apache][:user] = "apache"
  set[:apache][:binary] = "/usr/sbin/httpd"
  set[:apache][:icondir] = "/var/www/icons/"
when "debian","ubuntu"
  set[:apache][:package] = "apache2"
  set[:apache][:dir] = "/etc/apache2"
  set[:apache][:log_dir] = "/var/log/apache2"
  set[:apache][:user] = "www-data"
  set[:apache][:binary] = "/usr/sbin/apache2"
  set[:apache][:icondir] = "/usr/share/apache2/icons/"
end

###
# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
default[:apache][:listen_ports] = [ "80","443" ]
default[:apache][:contact] = "root@#{node[:hostname]}"
default[:apache][:timeout] = 30
default[:apache][:keepalive] = "On"
default[:apache][:keepaliverequests] = 100
default[:apache][:keepalivetimeout] = 5

# Lets figure maxclients depending on size
maxclients = node[:memory][:total].to_i / 15000
maxspareservers = Math.sqrt(maxclients) + 2
minspareservers = maxspareservers / 2

# Prefork Attributes
default[:apache][:prefork][:startservers] = 4
default[:apache][:prefork][:minspareservers] = minspareservers.to_i
default[:apache][:prefork][:maxspareservers] = maxspareservers.to_i
default[:apache][:prefork][:serverlimit] = maxclients.to_i
default[:apache][:prefork][:maxclients] = maxclients.to_i
default[:apache][:prefork][:maxrequestsperchild] = 1000
default[:apache][:prefork][:listenbacklog] = (maxclients.to_i)*2
