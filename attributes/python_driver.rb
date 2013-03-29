#
# Cookbook Name:: cubrid
# Attributes:: python_driver
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# Latest build numbers for each CUBRID Python version in the form of 'version'=>'build_number'.
build_numbers = {'9.1.0' => '0002', '9.0.0' => '0001', '8.4.3' => '0004', '8.4.1' => '0001', '8.4.0' => '0001'}

# The default version of CUBRID to install.
default['cubrid']['version'] = "9.1.0"

# The defalut Python Development Package required to build Python modules.
if platform_family?('rhel')
  set['cubrid']['python_dev_package']  = 'python-devel'
else
  set['cubrid']['python_dev_package']  = 'python-dev'
end

# The version of a CUBRID Python driver to install from PIP.
set['cubrid']['python_version'] = "#{node['cubrid']['version']}.#{build_numbers[node['cubrid']['version']]}"
# The name of a PIP package to install CUBRID Python driver.
set['cubrid']['python_package'] = "CUBRID-Python"

# The name of the directory where the archive is extracted.
set['cubrid']['python_dirname'] = "RB-#{node['cubrid']['version']}"
# The file name of the archive to download.
set['cubrid']['python_filename'] = "cubrid-python-#{node['cubrid']['python_version']}.tar.gz"

# The full URL of the TAR archive to download.
set['cubrid']['python_tar_url'] = "https://sourceforge.net/projects/cubrid/files/CUBRID-Drivers/Python_Driver/#{node['cubrid']['version']}/Linux/#{node['cubrid']['python_filename']}/download"

# The home directory of a Vagrant user.
default['cubrid']['user_home_dir'] = "/home/vagrant"
# The target directory to install CUBRID.
default['cubrid']['home'] = "/opt/cubrid"
