#
# Cookbook Name:: skveez
# Recipe:: app
#
# Copyright 2009-2011, Opscode, Inc.
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

include_recipe "skveez"
include_recipe "nginx"
include_recipe "php"
include_recipe "git"

%w{ compass }.each do |package|
  gem_package package do
    action :install 
  end	
end

config = Hash.new
config['owner'] = `echo $USER`
config['group'] = "www-data"
config['home']  = `echo ~`.split("\n").first
config['target'] = node["skveez"]["target"]
config['repository'] = node["skveez"]["repository"]
config['port'] = 80
  
directory "target directory" do
  path config['target']
  group config['group']
  recursive true
  mode 0755
end

execute "chown -hR :#{config['group']} #{config['target']}"

#database params
db = search(:node, 'role:skveez_db').first

template "#{node['php']['fpm_conf_dir']}/pool.d/database.conf" do
  source "params.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :env => {
      :database__host => db['ipaddress'],
      :database__port => db['mysql']['port'],
      :database__name => db['skveez']['database']['name'],
      :database__user => db['skveez']['database']['user'],
      :database__password => db['skveez']['database']['password'] 
    }
  )
  only_if { db }
end

#redis params
redis = search(:node, 'role:skveez_redis').first

template "#{node['php']['fpm_conf_dir']}/pool.d/redis.conf" do
  source "params.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :env => {
      :redis__host => redis['ipaddress'],
      :redis__port => '6379'
    }
  )
  only_if { redis }
end

template "/etc/nginx/sites-available/skveez" do
  cookbook "skveez"
  source "skveez.erb"
  variables( 
    :host => "skveez.#{node['fqdn']}",
    :port => config['port'],
    :name  => "skveez",
    :index => "app_dev.php",
    :root => config['target']
    )
end

nginx_site 'skveez'