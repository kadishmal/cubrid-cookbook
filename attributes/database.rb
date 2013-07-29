#
# Cookbook Name:: cubrid
# Attributes:: database
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# the default target directory to install CUBRID
default['cubrid']['home'] = "/opt/cubrid"

# the directory to store CUBRID databases
set['cubrid']['databases_dir'] = "#{node['cubrid']['home']}/databases"

# "db_volume_size" parameter value used in conf/cubrid.conf
default['cubrid']['db_volume_size'] = "512M"
# "log_volume_size" parameter value used in conf/cubrid.conf
default['cubrid']['log_volume_size'] = "#{node['cubrid']['db_volume_size']}"
