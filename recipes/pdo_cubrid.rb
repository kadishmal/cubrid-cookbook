#
# Cookbook Name:: cubrid
# Recipe:: pdo_cubrid
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe "php"
include_recipe "cubrid"

USER_HOME_DIR = "#{node['cubrid']['user_home_dir']}"
CUBRID_HOME_DIR = "#{node['cubrid']['home']}"

PDO_FILENAME = "#{node['cubrid']['pdo_filename']}"
PDO_DIRNAME = "#{node['cubrid']['pdo_dirname']}"

remote_file "#{USER_HOME_DIR}/#{PDO_FILENAME}" do
  user "vagrant"
  source "#{node['cubrid']['pdo_url']}"
  mode 0644
  not_if "php -i | grep 'Client API version => 9.0.0.0001'"
end

execute "extract #{PDO_FILENAME}" do
  user "vagrant"
  cwd "#{USER_HOME_DIR}"
  command "tar -zxf #{PDO_FILENAME}"
  not_if "php -i | grep 'Client API version => 9.0.0.0001'"
end

file "#{USER_HOME_DIR}/#{PDO_FILENAME}" do
  action :delete
  not_if "php -i | grep 'Client API version => 9.0.0.0001'"
end

execute "configure phpize for #{PDO_FILENAME}" do
  cwd "#{USER_HOME_DIR}/#{PDO_DIRNAME}"
  command "phpize"
  not_if "php -i | grep 'Client API version => 9.0.0.0001'"
end

execute "configure #{PDO_FILENAME}" do
  cwd "#{USER_HOME_DIR}/#{PDO_DIRNAME}"
  command "./configure --with-pdo-cubrid=#{CUBRID_HOME_DIR}"
  not_if "php -i | grep 'Client API version => 9.0.0.0001'"
end

execute "install #{PDO_FILENAME}" do
  user "root"
  cwd "#{USER_HOME_DIR}/#{PDO_DIRNAME}"
  command "make && make install"
  not_if "php -i | grep 'Client API version => 9.0.0.0001'"
end

template "#{node['cubrid']['pdo_ext_conf']}" do
  source "pdo_cubrid.ini.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
  not_if "php -i | grep 'Client API version => 9.0.0.0001'"
end

directory "#{USER_HOME_DIR}/#{PDO_DIRNAME}" do
  user "root"
  recursive true
  action :delete
  not_if "php -i | grep 'Client API version => 9.0.0.0001'"
end

file "#{USER_HOME_DIR}/package.xml" do
  user "root"
  action :delete
  not_if "php -i | grep 'Client API version => 9.0.0.0001'"
end

service "apache2" do
  action :restart
  not_if "php -i | grep 'Client API version => 9.0.0.0001'"
end