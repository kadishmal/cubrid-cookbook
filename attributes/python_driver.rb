#
# Cookbook Name:: cubrid
# Attributes:: python_driver
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# Latest build numbers for each CUBRID Python version in the form of 'version'=>'build_number'.
build_numbers = {'9.0.0' => '0001', '8.4.3' => '0002', '8.4.1' => '0001', '8.4.0' => '0001'}

# The default version of CUBRID to install.
default['cubrid']['version'] = "9.0.0"

# The version of a CUBRID Python driver to install from PIP.
set['cubrid']['python_version'] = "#{node['cubrid']['version']}.#{build_numbers[node['cubrid']['version']]}"
# The name of a PIP package to install CUBRID Python driver.
set['cubrid']['python_package'] = "CUBRID-Python"
