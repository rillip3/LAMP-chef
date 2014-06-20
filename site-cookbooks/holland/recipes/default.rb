#
# Cookbook Name:: holland
# Recipe:: default
#
# Copyright 2010, Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
  when "redhat","centos"
    package "python-setuptools"
    package "holland"
  when "ubuntu","debian"
    package "python-support"
    package "python-pkg-resources"
    cookbook_file "/tmp/holland_#{node[:holland][:ver]}_all.deb" do
      source "holland_#{node[:holland][:ver]}_all.deb"
      owner "root"
      group "root"
      mode "0755"
    end

    package "holland" do
      source "/tmp/holland_#{node[:holland][:ver]}_all.deb"
      provider Chef::Provider::Package::Dpkg
    end

    file "/tmp/holland_#{node[:holland][:ver]}_all.deb" do
      action :delete
    end
end

directory "/usr/lib/rackspace-monitoring-agent/plugins" do
  owner "root"
  group "root"
  mode 0755
  action :create
  recursive true
end

