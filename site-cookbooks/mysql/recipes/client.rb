#
# Cookbook Name:: mysql
# Recipe:: client
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if platform?("redhat", "centos") and node[:platform_version].to_f >= 6.0
  l = package "mysql-libs" do
    options "--nodeps"
    action :nothing
    provider Chef::Provider::Package::Rpm
    only_if "rpm -q mysql-libs"
  end
  l.run_action(:remove)
end

if platform?("redhat", "centos") and node[:platform_version].to_f < 6
  rmsql = execute "rm mysql 5.0" do
    command "yum -d0 -e0 -y remove mysql"
    only_if "rpm -q mysql"
    action :nothing
  end
  rmsql.run_action(:run)
end

p = package "mysql-devel" do
  case node[:platform]
  when "centos","redhat"
      package_name "mysql55-devel"
  when "debian"
    package_name "libmysqlclient15-dev"
  when "ubuntu"
    if node[:platform_version].to_f <= 9.04
      package_name "libmysqlclient15-dev"
    else
      package_name "libmysqlclient-dev"
    end
  end
  action :nothing
end

p.run_action(:install)

o = package "mysql-client" do
  case node[:platform]
  when "centos","redhat"
      package_name "mysql55"
  when "debian","ubuntu"
    package_name "mysql-client"
  end
  action :nothing
end

o.run_action(:install)

case node[:platform]
when "centos","redhat"
  package "ruby-mysql" do
    action :install
  end

else
  if (Chef::VERSION.split('.').map{|s|s.to_i} <=> "0.10.10".split('.').map{|s|s.to_i}) > 0
    chef_gem "mysql"
  else
    r = gem_package "mysql" do
      action :nothing
    end

    r.run_action(:install)
  end
end
