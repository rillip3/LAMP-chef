::Chef::Node.send(:include, Opscode::OpenSSL::Password)

set_unless[:holland][:server_holland_password] = secure_password
default[:holland][:dir] = "/var/lib/mysqlbackup"
default[:holland][:ver] = "1.0.10-1"
