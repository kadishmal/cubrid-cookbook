#
# Cookbook Name:: cubrid
# Attributes:: default
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# the version of CUBRID to install
default['cubrid']['version'] = "9.0.0"
# the full version of CUBRID including the build number
default['cubrid']['full_version'] = "#{default['cubrid']['version']}.0478"

# the file name of the archive to download
default['cubrid']['filename'] = "CUBRID-#{default['cubrid']['full_version']}-linux.i386.tar.gz"

# the full URL of the TAR archive to download
default['cubrid']['tar_url'] = "http://ftp.cubrid.org/CUBRID_Engine/#{default['cubrid']['version']}/Linux/#{default['cubrid']['filename']}"

# the home directory of a Vagrant user
default['cubrid']['user_home_dir'] = "/home/vagrant"
# the target directory to install CUBRID
default['cubrid']['home'] = "/opt/cubrid"

# the file name of the shell scipt which sets environmental variables for CUBRID
default['cubrid']['env_script_name'] = "cubrid.sh"
# the full path of the original shell script distributed with CUBRID source
default['cubrid']['env_script_original'] = "#{default['cubrid']['home']}/share/rpm/#{default['cubrid']['env_script_name']}"
# the target path where the shell script should be placed so that when a user logs in the variables are available.
default['cubrid']['env_script'] = "/etc/profile.d/#{default['cubrid']['env_script_name']}"
