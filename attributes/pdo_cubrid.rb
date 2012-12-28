#
# Cookbook Name:: cubrid
# Attributes:: pdo_cubrid
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# latest build numbers for each CUBRID PDO version in the form of 'version'=>'build_number'
build_numbers = {'9.0.0' => '0001', '8.4.3' => '0001', '8.4.0' => '0002'}

# the default version of CUBRID to install
default['cubrid']['version'] = "9.0.0"

# for CUBRID 8.4.1 use PDO driver 8.4.0 as they are compatible.
# No separeate PDO driver version was released for CUBRID 8.4.1.
set['cubrid']['pdo_version'] = node['cubrid']['version'] == "8.4.1" ? "8.4.0" : node['cubrid']['version']
# the version of a CUBRID PDO driver to install from PECL
set['cubrid']['pdo_version'] = "#{node['cubrid']['pdo_version']}.#{build_numbers[node['cubrid']['pdo_version']]}"
# the name of a PECL package to install CUBRID PDO driver
set['cubrid']['pdo_package'] = "PDO_CUBRID-#{node['cubrid']['pdo_version']}"

# the full path of pdo_cubrid.ini
set['cubrid']['pdo_ext_conf'] = "/etc/php5/conf.d/pdo_cubrid.ini"
# the directives which should be placed in pdo_cubrid.ini files; these are populate to pdo_cubrid.ini.erb template of this cookbook.
set['cubrid']['pdo_directives'] = {:extension => "pdo_cubrid.so"}