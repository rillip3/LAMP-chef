#
# Cookbook Name:: apache2
# Definition:: secure_web_app
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

define :secure_web_app, :template => "secure_web_app.conf.erb" do
  
  application_name = params[:name]

  include_recipe "apache2"
  include_recipe "apache2::mod_rewrite"
  include_recipe "apache2::mod_deflate"
  include_recipe "apache2::mod_headers"
  
  case node.platform
    when "ubuntu", "debian"
      template "#{node[:apache][:dir]}/sites-available/#{application_name}_ssl.conf" do
        source params[:template]
        owner "root"
        group "root"
        mode 0644
        if params[:cookbook]
          cookbook params[:cookbook]
        end
        variables(
          :application_name => application_name,
          :params => params
        )
        if File.exists?("#{node[:apache][:dir]}/sites-enabled/#{application_name}_ssl.conf")
          notifies :reload, resources(:service => "apache2"), :delayed
        end
     end
     apache_site "#{params[:name]}_ssl.conf" do
       enable enable_setting
     end
   else
      template "#{node[:apache][:dir]}/vhost.d/#{application_name}_ssl.conf" do
        source params[:template]
        owner "root"
        group "root"
        mode 0644
        if params[:cookbook]
          cookbook params[:cookbook]
        end
        variables(
          :application_name => application_name,
          :params => params
        )
        if File.exists?("#{node[:apache][:dir]}/vhost.d/#{application_name}_ssl.conf")
          notifies :reload, resources(:service => "apache2"), :delayed
        end
      end 
   end
end
