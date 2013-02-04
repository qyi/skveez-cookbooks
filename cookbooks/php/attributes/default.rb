#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php
# Attribute:: default
#
# Copyright 2011, Opscode, Inc.
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

lib_dir = kernel['machine'] =~ /x86_64/ ? 'lib64' : 'lib'

default['php']['install_method'] = 'source'
default['php']['directives'] = {}

case node["platform_family"]
when "rhel", "fedora"
  default['php']['conf_dir']      = '/etc'
  default['php']['ext_conf_dir']  = '/etc/php.d'
  default['php']['fpm_user']      = 'nobody'
  default['php']['fpm_group']     = 'nobody'
  default['php']['ext_dir']       = "/usr/#{lib_dir}/php/modules"
when "debian"
  default['php']['conf_dir']      = '/etc/php5/cli'
  default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['php']['fpm_user']      = 'www-data'
  default['php']['fpm_group']     = 'www-data'
  default['php']['fpm_conf_dir']  = '/etc/php5/fpm'
else
  default['php']['conf_dir']      = '/etc/php5/cli'
  default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
  default['php']['fpm_user']      = 'www-data'
  default['php']['fpm_group']     = 'www-data'
  default['php']['fpm_conf_dir']  = '/etc/php5/fpm'
end

default['php']['url'] = 'http://us.php.net/distributions'
default['php']['version'] = '5.4.10'
default['php']['checksum'] = '35c9cb8d57ce1b22d6859f191a273041947241c3bae1455fae91848255c825a2'
default['php']['prefix_dir'] = '/usr/local'

default['php']['configure_options'] = %W{--prefix=#{php['prefix_dir']}
                                          --with-config-file-path=#{php['conf_dir']}
                                          --with-config-file-scan-dir=#{php['ext_conf_dir']}
                                          --with-pear
                                          --enable-fpm
                                          --with-fpm-user=#{php['fpm_user']}
                                          --with-fpm-group=#{php['fpm_group']}
                                          --with-zlib
                                          --with-openssl
                                          --with-kerberos
                                          --with-bz2
                                          --with-curl
                                          --enable-ftp
                                          --enable-zip
                                          --enable-exif
                                          --enable-intl
                                          --with-gd
                                          --enable-gd-native-ttf
                                          --with-freetype-dir=/usr/lib/i386-linux-gnu
                                          --with-gettext
                                          --with-gmp
                                          --with-mhash
                                          --with-iconv
                                          --with-imap
                                          --with-imap-ssl
                                          --enable-sockets
                                          --enable-soap
                                          --with-xmlrpc
                                          --with-mcrypt
                                          --enable-mbstring
                                          --with-t1lib
                                          --with-mysql
                                          --with-mysqli=/usr/bin/mysql_config
                                          --with-mysql-sock
                                          --with-pgsql=/usr/bin/pg_config
                                          --with-pdo-pgsql=/usr/bin/pg_config
                                          --with-sqlite3
                                          --with-pdo-mysql
                                          --with-pdo-sqlite}

default['php']['configs']['timezone'] = 'Europe/Moscow'
default['php']['configs']['post_max_size'] = '16M'
default['php']['configs']['max_execution_time'] = 300
default['php']['configs']['max_input_time'] = 300
default['php']['configs']['upload_max_filesize'] = '10M'
