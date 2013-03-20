#
# Cookbook Name:: cubrid
# Attributes:: default
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

include_attribute "cubrid::broker"

# latest build numbers for each CUBRID version in the form of 'version'=>'build_number'
build_numbers = {'9.0.0' => '0478', '8.4.3' => '1005', '8.4.1' => '7007'}

# the default version of CUBRID to install
default['cubrid']['version'] = "9.0.0"
# the full version of CUBRID including the build number
set['cubrid']['full_version'] = "#{node['cubrid']['version']}.#{build_numbers[node['cubrid']['version']]}"
# the architecture of CUBRID binaries to install based on the current system architecture
set['cubrid']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"

# the file name of the archive to download
set['cubrid']['filename'] = "CUBRID-#{node['cubrid']['full_version']}-linux.#{node['cubrid']['arch']}.tar.gz"

# the full URL of the TAR archive to download
set['cubrid']['tar_url'] = "https://sourceforge.net/projects/cubrid/files/CUBRID-#{node['cubrid']['version']}/Linux/#{node['cubrid']['filename']}/download"

# the home directory of a Vagrant user
default['cubrid']['user_home_dir'] = "/home/vagrant"
# the target directory to install CUBRID
default['cubrid']['home'] = "/opt/cubrid"

# Set the maximum number of clients this Server should respond to.
# +1 is for Query Editory Broker.
# Calculated based on the recommendation from the manual page
# http://www.cubrid.org/manual/843/en/Connection-Related%20Parameters
default['cubrid']['max_clients'] = node['cubrid']['max_num_appl_server'] * (node['cubrid']['broker_count'] + 1) + 10

# The configurations directory.
set['cubrid']['conf_dir'] = "#{node['cubrid']['home']}/conf"
# Full path to cubrid.conf.
set['cubrid']['conf'] = "#{node['cubrid']['conf_dir']}/cubrid.conf"

# the file name of the shell scipt which sets environmental variables for CUBRID
set['cubrid']['env_script_name'] = "cubrid.sh"
# the full path of the original shell script distributed with CUBRID source
set['cubrid']['env_script_original'] = "#{node['cubrid']['home']}/share/rpm/#{node['cubrid']['env_script_name']}"
# the target path where the shell script should be placed so that when a user logs in the variables are available.
set['cubrid']['env_script'] = "/etc/profile.d/#{node['cubrid']['env_script_name']}"
