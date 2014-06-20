#
# Cookbook Name:: apache2
# Recipe:: php5 
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

include_recipe "php5"
case node[:platform]
when "ubuntu","debian"
    package "libapache2-mod-php5"
end

if (node[:platform] == "ubuntu" && node[:platform_version].to_f > 13.04)
    template "mpm_prefork.conf" do
      source "mods/mpm_prefork.conf.erb"
      path "#{node[:apache][:dir]}/mods-available/mpm_prefork.conf"
      owner "root"
      group "root"
      mode 0644
    end
    execute "a2enmod mpm_prefork" do
      command "/usr/sbin/a2enmod #{params[:name]}"
      notifies :restart, resources(:service => "apache2")
    end
end

   
