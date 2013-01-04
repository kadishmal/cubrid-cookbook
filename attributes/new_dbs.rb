#
# Cookbook Name:: cubrid
# Attributes:: new_dbs
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_attribute "cubrid::database"

# a default list of databases to create
default['cubrid']['new_dbs'] = []
