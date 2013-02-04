#
# Cookbook Name:: cubrid
# Recipe:: python_driver
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe "cubrid"

major_version = node['platform_version'].split('.').first.to_i

# On CentOS 5.x by default Python 2.4 is installed. However,
# the "python" cookbook installs Python 2.6 because "pip" requires
# at least Python 2.5.
# To enable the default Python 2.4 work with CUBRID, install
# the Python driver from source
if platform_family?('rhel') && major_version < 6
	include_recipe "cubrid::python_driver_source"
else
	include_recipe "cubrid::python_driver_pip"
end
