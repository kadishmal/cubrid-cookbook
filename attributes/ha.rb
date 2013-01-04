#
# Cookbook Name:: cubrid
# Attributes:: ha
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

include_attribute "cubrid::database"

#######################################################
# the following are configurations for cubrid_ha.conf #
#######################################################

# a default list of databases to create and configure for CUBRID HA
default['cubrid']['ha_dbs'] = ["testdb"]
# the name of the HA group
default['cubrid']['ha_group'] = "cubrid"
# a default list of hosts to join ha_group
# in the form of { "node1" => "IP 1", "node2" => "IP 2" ... }
default['cubrid']['ha_hosts'] = {}

HA_DB_LIST = ""
HA_HOSTS = ""

node['cubrid']['ha_dbs'].each do |db|
	HA_DB_LIST << (HA_DB_LIST == "" ? "" : ",") << db
end

node['cubrid']['ha_hosts'].each do |host, ip|
	HA_HOSTS << (HA_HOSTS == "" ? "" : ":") << host
end

# ha_db_list in the form of db1,db2...
set['cubrid']['ha_db_list'] = HA_DB_LIST
# ha_hosts_list in the form of node1:node2...
set['cubrid']['ha_hosts_list'] = HA_HOSTS
# ha_node_list in the form of ha_group@ha_hosts_list
set['cubrid']['ha_node_list'] = "#{node['cubrid']['ha_group']}@#{HA_HOSTS}"

# the configurations directory
set['cubrid']['conf_dir'] = "#{node['cubrid']['home']}/conf"
# full path to cubrid.conf
set['cubrid']['conf'] = "#{node['cubrid']['conf_dir']}/cubrid.conf"
# full path to cubrid_ha.conf
set['cubrid']['ha_conf'] = "#{node['cubrid']['conf_dir']}/cubrid_ha.conf"
