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

include_recipe "java"

remote_file "#{Chef::Config[:file_cache_path]}/elasticsearch.deb" do
  source "http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{node['skveez']['elasticsearch_version']}.deb"
  not_if { File.exists? "#{Chef::Config[:file_cache_path]}/elasticsearch.deb" }
  mode 00755
end

package "elasticsearch" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/elasticsearch.deb"
  provider Chef::Provider::Package::Dpkg
  notifies :start, 'service[elasticsearch]'
  not_if `which elasticsearch`
end

service "elasticsearch" do
  supports :status => true, :restart => true, :start => true
  action [ :enable, :start ]
end