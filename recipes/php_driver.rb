#
# Cookbook Name:: cubrid
# Recipe:: php_driver
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe "build-essential"
include_recipe "php"
# Since CUBRID PHP 9.1.0.0003, there is no need to install CUBRID. The driver already
# includes the CCI driver.
include_recipe "cubrid" if node['cubrid']['version'] < '9.1.0'

CUBRID_PHP_INSTALLED = "pecl list | egrep '^CUBRID\s+#{node['cubrid']['php_version']}'"
CUBRID_PHP_ENABLED = "php -i | grep 'Driver Version => #{node['cubrid']['php_version']}'"

# PHP 5.3.3 installed via YUM seems to be missing "libgcrypt-devel" library which is required to build PECL packages.
# On other platforms, `php533_deps` is an empty array, so will not install anything.
# See http://jira.cubrid.org/browse/APIS-414
node['cubrid']['php533_deps'].each do |pkg|
	package pkg do
	  action :install
	  only_if "php --version | grep 'PHP 5.3.3'"
	end
end

# CUBRID PHP driver earlier than 9.1.0.0003 requires CUBRID CCI to be available on the same machine.
# The installation package asks to enter the root directory path where the driver can be found,
# so we echo the path.
execute "echo '#{node['cubrid']['home']}' | pecl install #{node['cubrid']['php_package']}" do
  not_if "#{CUBRID_PHP_INSTALLED}"
end

# Create .ini file to tell PHP to load CUBRID extension.
template "#{node['cubrid']['php_ext_conf']}" do
  source "php_driver.ini.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
  not_if "#{CUBRID_PHP_ENABLED}"
end
