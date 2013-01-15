#
# Cookbook Name:: cubrid
# Attributes:: shard
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

include_attribute "cubrid::database"

#######################################################
# the following are configurations for cubrid_ha.conf #
#######################################################

# A default database to shard. Will be created if it doesn't exist.
default['cubrid']['shard_db'] = ""
# The default database user for the SHARD database.
default['cubrid']['shard_user'] = "shard"
# The default password for a SHARD database user.
default['cubrid']['shard_user_password'] = "shard123"
# A default list of hosts for CUBRID SHARD in the form of array of hash objects
# where each hash object represents a single shard
# which contains a list of host=>ip key/values for HA (if necessary):
# [
#   { "shard1node1" => "IP 1", "shard1node2" => "IP 2", "shard1node3" => "IP 3" }
#   { "shard2node1" => "IP 4", "shard2node2" => "IP 5", "shard2node3" => "IP 6" }
#   { "shard3node1" => "IP 7", "shard3node2" => "IP 8", "shard3node3" => "IP 9" }
# ]
# The above will distributed data between 3 SHARD nodes: shard1node1, shard2node1, shard3node1.
# Each of those nodes can be configured in HA for auto failover among 3 other HA nodes.
# In the above case shard1node1 is a master, while shard1node2 and shard1node3 are slave nodes.
default['cubrid']['shard_hosts'] = []

# the configurations directory
set['cubrid']['conf_dir'] = "#{node['cubrid']['home']}/conf"
# full path to cubrid.conf
set['cubrid']['conf'] = "#{node['cubrid']['conf_dir']}/cubrid.conf"
# full path to shard.conf
set['cubrid']['shard_conf'] = "#{node['cubrid']['conf_dir']}/shard.conf"
# full path to shard_connection.txt
set['cubrid']['shard_connection_txt'] = "#{node['cubrid']['conf_dir']}/shard_connection.txt"
# full path to shard_key.txt
set['cubrid']['shard_key_txt'] = "#{node['cubrid']['conf_dir']}/shard_key.txt"