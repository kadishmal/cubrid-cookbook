#
# Cookbook Name:: cubrid
# Attributes:: shard_mysql
#
# Copyright 2013, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

include_attribute "cubrid::shard"

# Install CUBRID SHARD on every node. Defaults to `false`. If `true`,
# users may later choose to start CUBRID SHARD on more than one
# node to provide [API level load balancing](http://www.cubrid.org/blog/news/cubrid-8-4-3-with-db-sharding-and-api-level-load-balancing-is-here).
# However, even if installed, CUBRID SHARD will be started only
# on the last node as usually. Users need to start additional
# CUBRID SHARD Brokers manually.
default['cubrid']['install_shard_on_all_nodes'] = false
