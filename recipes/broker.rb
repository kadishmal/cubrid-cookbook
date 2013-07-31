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

# Stop CUBRID Broker Service.
# I have specifically separated this command into stop/start
# instead of restart because I don't want to restart the
# Broker Service if its configuration file will not be udpated.
execute "cubrid broker stop" do
  not_if "cat #{BROKER_CONF} | grep 'Cookbook Name:: cubrid'"
end

# update cubrid_broker.conf
template BROKER_CONF do
  source "broker.cubrid_broker.conf.erb"
  not_if "cat #{BROKER_CONF} | grep 'Cookbook Name:: cubrid'"
end

# Start CUBRID Broker Service.
execute "cubrid broker start"
