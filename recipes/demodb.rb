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

# Create a "demodb" directory if it doesn't exist.
directory "#{CUBRID_DEMODB_DIR}" do
  not_if "test -d #{CUBRID_DEMODB_DIR}"
end

# Install a demodb database if it doesn't exist.
execute "#{node['cubrid']['demodb_script']}" do
  cwd "#{CUBRID_DEMODB_DIR}"
  not_if "test -f #{CUBRID_DEMODB_DIR}/demodb"
end

execute "cubrid server start demodb"
