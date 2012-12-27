#
# Cookbook Name:: cubrid
# Attributes:: pdo_cubrid
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# the name of a PECL package to install CUBRID PDO driver
default['cubrid']['pdo_package'] = "PDO_CUBRID-#{node['cubrid']['version']}.0001"

# the full path of pdo_cubrid.ini
default['cubrid']['pdo_ext_conf'] = "/etc/php5/conf.d/pdo_cubrid.ini"
# the directives which should be placed in pdo_cubrid.ini files; these are populate to pdo_cubrid.ini.erb template of this cookbook.
default['cubrid']['pdo_directives'] = {:extension => "pdo_cubrid.so"}