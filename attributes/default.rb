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

# latest build numbers for each CUBRID version in the form of 'version'=>'build_number'
build_numbers = {'9.1.0' => '0212', '9.0.0' => '0478', '8.4.3' => '1005', '8.4.1' => '7007'}

# The default version of CUBRID to install
default['cubrid']['version'] = "9.1.0"
# The full version of CUBRID including the build number
set['cubrid']['full_version'] = "#{node['cubrid']['version']}.#{build_numbers[node['cubrid']['version']]}"
# The architecture of CUBRID binaries to install based on the current system architecture
set['cubrid']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"

# The file name of the archive to download
set['cubrid']['filename'] = "CUBRID-#{node['cubrid']['full_version']}-linux.#{node['cubrid']['arch']}.tar.gz"

# the full URL of the TAR archive to download
set['cubrid']['tar_url'] = "https://sourceforge.net/projects/cubrid/files/CUBRID-#{node['cubrid']['version']}/Linux/#{node['cubrid']['filename']}/download"

# the target directory to install CUBRID
default['cubrid']['home'] = "/opt/cubrid"

default['cubrid']['charset'] = 'en_US'
default['cubrid']['lang'] = 'en_US'

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
