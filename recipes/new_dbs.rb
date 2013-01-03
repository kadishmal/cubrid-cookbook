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
	end
end
