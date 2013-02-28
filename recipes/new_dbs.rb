#
# Cookbook Name:: cubrid
# Recipe:: new_dbs
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe "cubrid"

node['cubrid']['new_dbs'].each do |db|
	cubrid_database db do
		action :create
		dbuser node['cubrid']['new_db_user']
		password node['cubrid']['new_db_user_pass']
	end
end
