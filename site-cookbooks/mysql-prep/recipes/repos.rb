# coding: utf-8
#
# Cookbook Name:: mysql-prep
# Recipe:: repos
#
# Copyright 2014
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node[:platform]
when "redhat","centos"
  iusfile = cookbook_file "/tmp/#{node[:mysql_prep][:ius]}" do
    source "#{node[:mysql_prep][:ius]}"
    action :nothing
  end
  iusfile.run_action(:create)

  ius = execute "ius-release" do
    command "rpm -U /tmp/#{node[:mysql_prep][:ius]}"
    not_if "rpm -q ius-release"
    action :nothing
  end
  begin
    ius.run_action(:run)
  rescue
    Chef::Log.info("IUS is already installed")
  end

  file "/tmp/#{node[:mysql_prep][:ius]}" do
    action :delete
  end

  repo = template "/etc/yum.repos.d/ius-dev.repo" do
    source "ius-dev.repo.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :version => node[:platform_version].to_i
    )
    action :nothing
  end
  repo.run_action(:create)

  repo = template "/etc/yum.repos.d/ius.repo" do
    source "ius.repo.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :version => node[:platform_version].to_i
    )
    action :nothing
  end
  repo.run_action(:create)

  repo = template "/etc/yum.repos.d/ius-testing.repo" do
    source "ius-testing.repo.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :version => node[:platform_version].to_i
    )
    action :nothing
  end
  repo.run_action(:create)
end
