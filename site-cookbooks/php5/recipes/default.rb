#
# Cookbook Name:: PHP5
# Recipe:: default
#
# Copyright 2010, Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

node[:php][:packages].each do |pkg|
  package pkg
end
