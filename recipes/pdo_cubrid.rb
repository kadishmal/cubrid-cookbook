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
