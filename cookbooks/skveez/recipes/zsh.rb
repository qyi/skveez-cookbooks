#
# Author::  Joshua Timberman (<joshua@opscode.com>)
# Author::  Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php
# Recipe:: default
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

include_recipe "zsh"
include_recipe "git"

user = "vyacheslav"
home = "/home/#{user}"


user user do
  gid "sudo"
  shell "/bin/zsh"
  supports :manage_home => true
  home home
end

execute "zsh configs" do
  cwd home
  command <<-EOH
    git clone -n https://github.com/vslinko/dotfiles.git
    mv dotfiles/.git .
    rm -r dotfiles
    git reset --hard
    git submodule update --init
  EOH
  not_if { File.exists? "#{home}/.oh-my-zsh" }
  action :run
end

directory "#{home}/.ssh" do
  owner "vyacheslav"
  mode 00700
  action :create
end

execute "remove password" do
  command "passwd -d vyacheslav"
end

template "#{home}/.ssh/authorized_keys" do
  source "authorized_keys.erb"
  cookbook "users"
  owner user
  mode "0600"
  variables :ssh_keys => node['skveez']['vyacheslav']['key']
end
