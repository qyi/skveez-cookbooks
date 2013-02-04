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

::Chef::Recipe.send(:include,Opscode::OpenSSL::Password)

include_recipe "mysql::server"
include_recipe "mysql::ruby"
require_recipe "database"

node.set_unless['skveez']['database']['password'] = secure_password
node.save unless Chef::Config[:solo]

mysql_connection = {
  :host => "localhost",
  :username => node['mysql']['root'],
  :password => node['mysql']['server_root_password']
}

mysql_database node['skveez']['database']['name'] do
  connection mysql_connection
  action :create
end

mysql_database_user node['skveez']['database']['user'] do
  connection mysql_connection
  password node['skveez']['database']['password']
  database_name node['skveez']['database']['name']
  host node['mysql']['bind_address']
  action [ :create, :grant]
end
