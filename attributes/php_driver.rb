#
# Cookbook Name:: cubrid
# Attributes:: php_cubrid
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# Latest build numbers for each CUBRID PHP version in the form of 'version'=>'build_number'.
build_numbers = {'9.1.0' => '0003', '9.0.0' => '0001', '8.4.3' => '0001', '8.4.1' => '0006'}

# The default version of CUBRID PHP driver to install.
default['cubrid']['version'] = "9.1.0"

# The version of a CUBRID PHP driver to install from PECL.
set['cubrid']['php_version'] = "#{node['cubrid']['version']}.#{build_numbers[node['cubrid']['version']]}"
# the name of a PECL package to install CUBRID PHP driver
set['cubrid']['php_package'] = "CUBRID-#{node['cubrid']['php_version']}"

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

# the full path of cubrid.ini
set['cubrid']['php_ext_conf'] = "#{node['cubrid']['php_ext_conf_dir']}/cubrid.ini"
# the directives which should be placed in cubrid.ini files; these are populate to cubrid.ini.erb template of this cookbook.
set['cubrid']['php_directives'] = {:extension => "cubrid.so"}
