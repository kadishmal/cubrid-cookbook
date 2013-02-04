#
# Cookbook Name:: cubrid
# Recipe:: pdo_cubrid
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe "build-essential"
include_recipe "php"
include_recipe "cubrid"

CUBRID_PDO_INSTALLED = "pecl list | egrep '^PDO_CUBRID\s+#{node['cubrid']['pdo_version']}'"
CUBRID_PDO_ENABLED = "php -i | grep 'Client API version => #{node['cubrid']['pdo_version']}'"

# PHP 5.3.3 installed via YUM seems to be missing "libgcrypt-devel" library which is required to build PECL packages.
# See http://jira.cubrid.org/browse/APIS-414
node['cubrid']['php533_deps'].each do |pkg|
	package pkg do
	  action :install
	  only_if "php --version | grep 'PHP 5.3.3'"
	end
end

# Also, when PHP is installed as a "package" (default), it get's installed from YUM. In this case
# PHP is configured with "--enable-pdo=shared" which means PDO module must be installed separately.
# See http://jira.cubrid.org/browse/APIS-415.
major_version = node['platform_version'].split('.').first.to_i

if platform_family?('rhel') && major_version < 6
  include_recipe 'yum::epel'
  pdo_pkg = "php53-pdo"
else
  pdo_pkg = "php-pdo"
end

package pdo_pkg do
  action :install
  only_if "php -i | grep 'enable-pdo=shared'"
end

execute "echo '#{node['cubrid']['home']}' | pecl install #{node['cubrid']['pdo_package']}" do
  not_if "#{CUBRID_PDO_INSTALLED}"
end

template "#{node['cubrid']['pdo_ext_conf']}" do
  source "pdo_cubrid.ini.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
  not_if "#{CUBRID_PDO_ENABLED}"
end
