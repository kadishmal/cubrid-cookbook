#
# Cookbook Name:: cubrid
# Attributes:: pdo_cubrid
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
# the default version of CUBRID to install
default['cubrid']['version'] = "9.0.0"

# the version of a CUBRID PDO driver to install from PECL
set['cubrid']['pdo_version'] = "#{node['cubrid']['version']}.0001"
# the name of a PECL package to install CUBRID PDO driver
set['cubrid']['pdo_package'] = "PDO_CUBRID-#{node['cubrid']['pdo_version']}"

# the full path of pdo_cubrid.ini
set['cubrid']['pdo_ext_conf'] = "/etc/php5/conf.d/pdo_cubrid.ini"
# the directives which should be placed in pdo_cubrid.ini files; these are populate to pdo_cubrid.ini.erb template of this cookbook.
set['cubrid']['pdo_directives'] = {:extension => "pdo_cubrid.so"}