#
# Cookbook Name:: cubrid
# Attributes:: new_dbs
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_attribute "cubrid::database"

# A default list of databases to create.
default['cubrid']['new_dbs'] = []
# A default user to create for each database.
# When empty, 'dba' will be the only administrator user.
default['cubrid']['new_db_user'] = ''
# A user password. If `new_db_user_pass` is specified but `new_db_user` is not,
# the specified password will be set to the default `dba` user.
default['cubrid']['new_db_user_pass'] = ''
