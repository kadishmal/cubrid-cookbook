#
# Cookbook Name:: cubrid
# Attributes:: default
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# the default version of CUBRID to install
default['cubrid']['version'] = "9.0.0"
# the full version of CUBRID including the build number
set['cubrid']['full_version'] = "#{node['cubrid']['version']}.0478"
set['cubrid']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"

# the file name of the archive to download
set['cubrid']['filename'] = "CUBRID-#{node['cubrid']['full_version']}-linux.#{node['cubrid']['arch']}.tar.gz"

# the full URL of the TAR archive to download
set['cubrid']['tar_url'] = "http://ftp.cubrid.org/CUBRID_Engine/#{node['cubrid']['version']}/Linux/#{node['cubrid']['filename']}"

# the home directory of a Vagrant user
default['cubrid']['user_home_dir'] = "/home/vagrant"
# the target directory to install CUBRID
default['cubrid']['home'] = "/opt/cubrid"

# the file name of the shell scipt which sets environmental variables for CUBRID
set['cubrid']['env_script_name'] = "cubrid.sh"
# the full path of the original shell script distributed with CUBRID source
set['cubrid']['env_script_original'] = "#{node['cubrid']['home']}/share/rpm/#{node['cubrid']['env_script_name']}"
# the target path where the shell script should be placed so that when a user logs in the variables are available.
set['cubrid']['env_script'] = "/etc/profile.d/#{node['cubrid']['env_script_name']}"
