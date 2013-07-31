#
# Cookbook Name:: cubrid
# Attributes:: pdo_cubrid
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# Latest build numbers for each CUBRID PDO version in the form of 'version'=>'build_number'.
build_numbers = {'9.1.0' => '0003', '9.0.0' => '0001', '8.4.3' => '0001', '8.4.0' => '0002'}

# The default version of CUBRID PDO driver to install.
default['cubrid']['version'] = "9.1.0"

# For CUBRID 8.4.1 use PDO driver 8.4.0 as they are compatible.
# No separeate PDO driver version was released for CUBRID 8.4.1.
set['cubrid']['pdo_version'] = node['cubrid']['version'] == "8.4.1" ? "8.4.0" : node['cubrid']['version']
# the version of a CUBRID PDO driver to install from PECL
set['cubrid']['pdo_version'] = "#{node['cubrid']['pdo_version']}.#{build_numbers[node['cubrid']['pdo_version']]}"
# the name of a PECL package to install CUBRID PDO driver
set['cubrid']['pdo_package'] = "PDO_CUBRID-#{node['cubrid']['pdo_version']}"

case node["platform"]
when "centos", "redhat", "fedora"
	# the location of PHP configuration directory
  set['cubrid']['php_ext_conf_dir']  = '/etc/php.d'
  # PHP 5.3.3 installed via YUM seems to be missing "libgcrypt-devel" library which is required to build PECL packages.
  set['cubrid']['php533_deps'] = ["libgcrypt-devel"]
else
  set['cubrid']['php_ext_conf_dir']  = '/etc/php5/conf.d'
  set['cubrid']['php533_deps'] = []
end

# the full path of pdo_cubrid.ini
set['cubrid']['pdo_ext_conf'] = "#{node['cubrid']['php_ext_conf_dir']}/pdo_cubrid.ini"
# the directives which should be placed in pdo_cubrid.ini files; these are populate to pdo_cubrid.ini.erb template of this cookbook.
set['cubrid']['pdo_directives'] = {:extension => "pdo_cubrid.so"}