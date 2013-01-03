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

# the directory where to install the demodb database
set['cubrid']['databases_dir'] = "#{node['cubrid']['home']}/databases"

# "data_buffer_size" parameter value
default['cubrid']['data_buffer_size'] = "100M"
# "db_volume_size" parameter value
default['cubrid']['db_volume_size'] = "100M"
# "log_volume_size" parameter value
default['cubrid']['log_volume_size'] = "#{node['cubrid']['db_volume_size']}"
