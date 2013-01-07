#
# Cookbook Name:: cubrid
# Attributes:: web_manager
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# latest build numbers for each CUBRID version in the form of 'version'=>'build_number'
build_numbers = {'9.0.0' => '0004', '8.4.3' => '0009', '8.4.1' => '0006'}

# the default version of CUBRID to install
default['cubrid']['version'] = "9.0.0"
# the full version of CUBRID including the build number
set['cubrid']['cwm_full_version'] = "#{node['cubrid']['version']}.#{build_numbers[node['cubrid']['version']]}"
# the architecture of CUBRID binaries to install based on the current system architecture
set['cubrid']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? "x86_64" : "i386"

# the name of the directory where the archive is extracted
set['cubrid']['cwm_dirname'] = "CUBRIDWebManager-#{node['cubrid']['cwm_full_version']}-linux-#{node['cubrid']['arch']}"
# the file name of the archive to download
set['cubrid']['cwm_filename'] = "#{node['cubrid']['cwm_dirname']}.tar.gz"

# the full URL of the TAR archive to download
set['cubrid']['cwm_tar_url'] = "https://sourceforge.net/projects/cubrid/files/CUBRID-AppsTools/CUBRID_Web_Manager/#{node['cubrid']['version']}/#{node['cubrid']['cwm_filename']}/download"

# the home directory of a Vagrant user
default['cubrid']['user_home_dir'] = "/home/vagrant"
# the target directory to install CUBRID
default['cubrid']['home'] = "/opt/cubrid"
