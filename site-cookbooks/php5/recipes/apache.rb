#
# Cookbook Name:: PHP5
# Recipe:: default
#
# Copyright 2010, Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"
include_recipe "php5"

directory node[:php][:session][:save_path] do
  owner "root"
  group node[:apache][:user]
  mode 0770
  recursive true
  action :create
end

template "php.ini" do
  path node[:php][:ini]
  source "php.ini.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "apache2")
end

