#
# Cookbook Name:: cubrid
# Attributes:: default
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

include_attribute "cubrid::broker"
include_attribute "cubrid::database"

# Latest build numbers for each CUBRID version in the form of 'version'=>'build_number'.
build_numbers = {'9.1.0' => '0212', '9.0.0' => '0478', '8.4.4' => '0227', '8.4.3' => '1005', '8.4.1' => '7007'}

# The default version of CUBRID to install.
default['cubrid']['version'] = "9.1.0"
# The full version of CUBRID including the build number.
set['cubrid']['full_version'] = "#{node['cubrid']['version']}.#{build_numbers[node['cubrid']['version']]}"
# The architecture of CUBRID binaries to install based on the current system architecture.
set['cubrid']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"

# The file name of the archive to download.
set['cubrid']['filename'] = "CUBRID-#{node['cubrid']['full_version']}-linux.#{node['cubrid']['arch']}.tar.gz"

# The full URL of the CUBRID archive to download.
set['cubrid']['download_url'] = "https://sourceforge.net/projects/cubrid/files/CUBRID-#{node['cubrid']['version']}/Linux/#{node['cubrid']['filename']}/download"

# The target directory to install CUBRID.
default['cubrid']['home'] = "/opt/cubrid"

# CUBRID_CHARSET variable is used since CUBRID version 9.0 for Unicode support.
default['cubrid']['charset'] = 'en_US'
# CUBRID 8.4.x uses CUBRID_LANG environment variable.
default['cubrid']['lang'] = 'en_US'

# "data_buffer_size" parameter value used in conf/cubrid.conf
default['cubrid']['data_buffer_size'] = "512M"
# Set the maximum number of clients this Server should respond to.
# +1 is for Query Editory Broker.
# Calculated based on the recommendation from the manual page
# http://www.cubrid.org/manual/843/en/Connection-Related%20Parameters
default['cubrid']['max_clients'] = node['cubrid']['max_num_appl_server'] * (node['cubrid']['broker_count'] + 1) + 10
# http://www.cubrid.org/manual/91/en/admin/config.html?highlight=memory%20parameters#memory-related-parameters
default['cubrid']['sort_buffer_size'] = '2M'
# default `--db-page-size` is 16KB = 16384 bytes.
# 4 pages = 4 * 16384 = 65536 bytes = 64KB
default['cubrid']['temp_file_memory_size_in_pages'] = 4
# `log_max_archives` server parameter value. Defaults to `INT_MAX` (`2147483647`).
default['cubrid']['log_max_archives'] = 2147483647
# `force_remove_log_archives` server parameter value. Defaults to `yes`.
default['cubrid']['force_remove_log_archives'] = 'yes'

# The configurations directory.
set['cubrid']['conf_dir'] = "#{node['cubrid']['home']}/conf"
# Full path to cubrid.conf.
set['cubrid']['conf'] = "#{node['cubrid']['conf_dir']}/cubrid.conf"
# full path to cm_httpd.conf
set['cubrid']['cm_httpd_conf'] = "#{node['cubrid']['conf_dir']}/cm_httpd.conf"

# the file name of the shell scipt which sets environmental variables for CUBRID
set['cubrid']['env_script_name'] = "cubrid.sh"
# the full path of the original shell script distributed with CUBRID source
set['cubrid']['env_script_original'] = "#{node['cubrid']['home']}/share/rpm/#{node['cubrid']['env_script_name']}"
# the target path where the shell script should be placed so that when a user logs in the variables are available.
set['cubrid']['env_script'] = "/etc/profile.d/#{node['cubrid']['env_script_name']}"
