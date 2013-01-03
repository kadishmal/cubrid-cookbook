#
# Cookbook Name:: cubrid
# Recipe:: php_cubrid
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe "build-essential"
include_recipe "php"
include_recipe "cubrid"

CUBRID_PHP_INSTALLED = "pecl list | egrep '^CUBRID\s+#{node['cubrid']['php_version']}'"
CUBRID_PHP_ENABLED = "php -i | grep 'Driver Version => #{node['cubrid']['php_version']}'"

execute "echo '#{node['cubrid']['home']}' | pecl install #{node['cubrid']['php_package']}" do
  not_if "#{CUBRID_PHP_INSTALLED}"
end

template "#{node['cubrid']['php_ext_conf']}" do
  source "php_driver.ini.erb"
  owner "root"
  group "root"
  mode 0644
  not_if "#{CUBRID_PHP_ENABLED}"
end
