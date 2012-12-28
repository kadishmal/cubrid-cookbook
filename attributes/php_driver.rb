#
# Cookbook Name:: cubrid
# Attributes:: php_cubrid
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
# the default version of CUBRID to install
default['cubrid']['version'] = "9.0.0"

# the version of a CUBRID PHP driver to install from PECL
set['cubrid']['php_version'] = "#{node['cubrid']['version']}.0001"
# the name of a PECL package to install CUBRID PHP driver
set['cubrid']['php_package'] = "CUBRID-#{node['cubrid']['php_version']}"

# the full path of cubrid.ini
set['cubrid']['php_ext_conf'] = "/etc/php5/conf.d/cubrid.ini"
# the directives which should be placed in cubrid.ini files; these are populate to cubrid.ini.erb template of this cookbook.
set['cubrid']['php_directives'] = {:extension => "cubrid.so"}
