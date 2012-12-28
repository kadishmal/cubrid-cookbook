#
# Cookbook Name:: cubrid
# Attributes:: demodb
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
# the default target directory to install CUBRID
default['cubrid']['home'] = "/opt/cubrid"

# the directory where to install the demodb database
set['cubrid']['demodb_dir'] = "#{node['cubrid']['home']}/databases/demodb"
# the full path of a script which install the demodb database
set['cubrid']['demodb_script'] = "#{node['cubrid']['home']}/demo/make_cubrid_demo.sh"
