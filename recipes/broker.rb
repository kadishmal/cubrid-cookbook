#
# Cookbook Name:: cubrid
# Recipe:: broker
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe "cubrid"

BROKER_CONF = node['cubrid']['broker_conf']

# update cubrid.conf
template BROKER_CONF do
  source "broker.cubrid_broker.conf.erb"
  not_if "cat #{BROKER_CONF} | grep 'Cookbook Name:: cubrid'"
end

# Start CUBRID Service.
execute "cubrid broker restart"
