::Chef::Node.send(:include, Opscode::OpenSSL::Password)

case node[:platform]
  when "ubuntu","debian"
    default[:phpmyadmin][:name] = "phpmyadmin"
  when "redhat","centos"
    default[:phpmyadmin][:name] = "phpMyAdmin"
end

default[:phpmyadmin][:auth_type] = "cookie"

default[:phpmyadmin][:user] = "serverinfo"
default[:phpmyadmin][:pass] = secure_password

default[:phpmyadmin][:blowfish_secret] = secure_password
