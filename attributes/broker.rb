#
# Cookbook Name:: cubrid
# Attributes:: broker
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# Default number of brokers to start.
default['cubrid']['broker_count'] = 1

# the target directory to install CUBRID
default['cubrid']['home'] = "/opt/cubrid"

# CUBRID configurations directory.
set['cubrid']['conf_dir'] = "#{node['cubrid']['home']}/conf"
# Full path to cubrid_broker.conf.
set['cubrid']['broker_conf'] = "#{node['cubrid']['conf_dir']}/cubrid_broker.conf"
