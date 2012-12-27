#
# Cookbook Name:: cubrid
# Attributes:: demodb
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# the target directory to install CUBRID
default['cubrid']['home'] = "/opt/cubrid"

# the full path of a script which install the demodb database
default['cubrid']['demodb_script'] = "#{default['cubrid']['home']}/demo/make_cubrid_demo.sh"
