#
# Cookbook Name:: cubrid
# Attributes:: perl_driver
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# Latest build numbers for each CUBRID Perl version in the form of 'version'=>'build_number'.
build_numbers = {'9.0.0' => '0001', '8.4.3' => '0001', '8.4.1' => '0001', '8.4.0' => '0002'}

# The default version of CUBRID to install.
default['cubrid']['version'] = "9.0.0"

# The version of a CUBRID Perl driver to install from CPAN.
set['cubrid']['perl_version'] = "#{node['cubrid']['version']}.#{build_numbers[node['cubrid']['version']]}"
# The file name of the the package to install.
set['cubrid']['perl_filename'] = "DBD-cubrid-#{node['cubrid']['perl_version']}.tar.gz"
