#
# Cookbook Name:: cubrid
# Attributes:: pdo_cubrid
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# the version of CUBRID to install
default['cubrid']['version'] = "9.0.0"
# the home directory of a Vagrant user
default['cubrid']['user_home_dir'] = "/home/vagrant"
# the directory where CUBRID is installed
default['cubrid']['home'] = "/opt/cubrid"

default['cubrid']['pdo_version'] = "#{default['cubrid']['version']}.0001"
# the name of a directory where PDO driver source code is extracted
default['cubrid']['pdo_dirname'] = "PDO_CUBRID-#{default['cubrid']['pdo_version']}"
# the file name of the archive to download
default['cubrid']['pdo_filename'] = "#{default['cubrid']['pdo_dirname']}.tgz"
# the full URL of the TAR archive to download
default['cubrid']['pdo_url'] = "http://pecl.php.net/get/#{default['cubrid']['pdo_filename']}"

# the full path of a directory where pdo_cubrid.ini should be placed
default['cubrid']['pdo_ext_conf_dir'] = '/etc/php5/conf.d'
# the full path of pdo_cubrid.ini
default['cubrid']['pdo_ext_conf'] = "#{default['cubrid']['pdo_ext_conf_dir']}/pdo_cubrid.ini"
# the directives which should be placed in pdo_cubrid.ini files; these are populate to pdo_cubrid.ini.erb template of this cookbook.
default['cubrid']['pdo_directives'] = {:extension => "pdo_cubrid.so"}