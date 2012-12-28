#
# Cookbook Name:: cubrid
# Recipe:: demodb
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe "cubrid"

CUBRID_DEMODB_DIR = "#{node['cubrid']['demodb_dir']}"

# create a "demodb" directory if it doesn't exist
directory "#{CUBRID_DEMODB_DIR}" do
  user "vagrant"
  action :create
  not_if "test -d #{CUBRID_DEMODB_DIR}"
end

# install demodb database if it doesn't exist
execute "#{node['cubrid']['demodb_script']}" do
  user "vagrant"
  cwd "#{CUBRID_DEMODB_DIR}"
  not_if "test -f #{CUBRID_DEMODB_DIR}/demodb"
end

execute "cubrid server start demodb" do
  user "vagrant"
end