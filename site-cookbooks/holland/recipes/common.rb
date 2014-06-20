#
# Cookbook Name:: holland
# Recipe:: common
#
# Copyright 2010, Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
  when "redhat","centos"
    package "MySQL-python"
    package "holland-common"
  when "ubuntu","debian"
    include_recipe "holland"
    package "python-mysqldb"

    cookbook_file "/tmp/holland-common_#{node[:holland][:ver]}_all.deb" do
      source "holland-common_#{node[:holland][:ver]}_all.deb"
      owner "root"
      group "root"
      mode "0755"
    end

    package "holland-common" do
      source "/tmp/holland-common_#{node[:holland][:ver]}_all.deb"
      provider Chef::Provider::Package::Dpkg
    end

    file "/tmp/holland-common_#{node[:holland][:ver]}_all.deb" do
      action :delete
    end
end
