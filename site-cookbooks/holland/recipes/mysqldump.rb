#
# Cookbook Name:: holland
# Recipe:: mysqldump
#
# Copyright 2010, Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

include_recipe "holland::common"
case node[:platform]
  when "redhat","centos"
    package "holland-mysqldump"
  when "ubuntu","debian"
    cookbook_file "/tmp/holland-mysqldump_#{node[:holland][:ver]}_all.deb" do
      source "holland-mysqldump_#{node[:holland][:ver]}_all.deb"
      owner "root"
      group "root"
      mode "0755"
    end

    package "holland-mysqldump" do
      source "/tmp/holland-mysqldump_#{node[:holland][:ver]}_all.deb"
      provider Chef::Provider::Package::Dpkg
    end

    file "/tmp/holland-mysqldump_#{node[:holland][:ver]}_all.deb" do
      action :delete
    end
end

template "/etc/holland/holland.conf" do
  source "holland.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :backupsets => "default"
  )
end

template "/etc/holland/backupsets/default.conf" do
  source "backupsets/default.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :plugin => "mysqldump",
    :keep   => "7",
    :hollpasswd => node[:holland][:server_holland_password]
  )
end

template "/etc/holland/holland.sql" do
  source "holland.sql.erb"
  mode 0644
  owner "root"
  group "root"
  variables :hollpasswd => node[:holland][:server_holland_password]
end

execute "holland-install-privileges" do
  command "/usr/bin/mysql -u root < /etc/holland/holland.sql"
  action :run
end

file "/etc/holland/holland.sql" do
  action :delete
end

execute "flush-privileges" do
  command "mysqladmin -u root flush-privileges"
  action :run
end

template "/etc/cron.d/holland" do
  source "holland.cron.erb"
  mode 0644
  owner "root"
  group "root"
end

execute "holland bk"
