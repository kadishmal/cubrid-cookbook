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
include_recipe "apache2"

CUBRID_PHP_INSTALLED = "php -i | grep 'Driver Version => #{node['cubrid']['php_version']}'"

execute "echo '#{node['cubrid']['home']}' | pecl install #{node['cubrid']['php_package']}" do
  not_if "#{CUBRID_PHP_INSTALLED}"
end

template "#{node['cubrid']['php_ext_conf']}" do
  source "php_driver.ini.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
  not_if "#{CUBRID_PHP_INSTALLED}"
end

service "apache2" do
  action :restart
end