# coding: utf-8
#
# Cookbook Name:: apache-prep
# Recipe:: default
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

# setup stock firewall rules
case node['platform']
  when "ubuntu","debian"
    include_recipe "firewall"

    firewall_rule "http" do
      port 80
      action :allow
    end

    firewall_rule "https" do
      port 443
      action :allow
    end

    firewall_rule "ssh" do
      port 22
      action :allow
    end

    firewall 'ufw' do
      action :enable
    end
  when "redhat","centos"
    execute "enable 22" do
      command "/sbin/iptables -I INPUT 1 -p tcp -m tcp -m comment --comment 'SSH' --dport 22 -j ACCEPT"
      not_if "/sbin/iptables -L -n | grep dpt:22"
      action :run
    end
    execute "enable 80" do
      command "/sbin/iptables -I INPUT 1 -p tcp -m tcp -m comment --comment 'HTTP' --dport 80 -j ACCEPT"
      not_if "/sbin/iptables -L -n | grep dpt:80"
      action :run
    end
    execute "enable 443" do
      command "/sbin/iptables -I INPUT 2 -p tcp -m tcp -m comment --comment 'HTTPS' --dport 443 -j ACCEPT"
      not_if "/sbin/iptables -L -n | grep dpt:443"
      action :run
    end
    execute "save iptables" do
      command "/sbin/service iptables save"
      action :run
    end
end
