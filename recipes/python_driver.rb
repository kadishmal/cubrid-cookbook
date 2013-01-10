#
# Cookbook Name:: cubrid
# Recipe:: python_driver
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe "python"
include_recipe "cubrid"

python_pip "#{node['cubrid']['python_package']}" do
  version "#{node['cubrid']['python_version']}"
  action :install
end
