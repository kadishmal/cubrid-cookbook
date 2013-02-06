#
# Cookbook Name:: cubrid
# Recipe:: python_driver_source
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe "cubrid"
include_recipe "build-essential"

TEMP_DIR = "/tmp"
DIR_NAME = "#{TEMP_DIR}/#{node['cubrid']['python_dirname']}"
DRIVER_FILE = "#{TEMP_DIR}/#{node['cubrid']['python_filename']}"

CUBRID_PYTHON_INSTALLED = "pydoc modules | grep cubrid"

# Install the defalut Python Development Package required to build Python modules.
package node['cubrid']['python_dev_package'] do
  action :install
  not_if CUBRID_PYTHON_INSTALLED
end

# Download the source archive.
remote_file DRIVER_FILE do
  source node['cubrid']['python_tar_url']
  mode 0644
  action :create_if_missing
  # Thank you Chef! It was a great birthday present to find out
  # that I can define multiple conditionals in one resource!
  not_if CUBRID_PYTHON_INSTALLED
  only_if "test -d #{node['cubrid']['home']}"
end

# Extract the archive.
execute "tar -zxf #{DRIVER_FILE} -C #{TEMP_DIR}" do
  only_if "test -f #{DRIVER_FILE}"
end

# Build the driver.
execute "python setup.py build" do
	cwd DIR_NAME
	only_if "test -d #{DIR_NAME}"
end

# Install the driver.
execute "python setup.py install" do
  cwd DIR_NAME
	only_if "test -d #{DIR_NAME}/build"
end

# Remove the archive.
file "#{DRIVER_FILE}" do
  action :delete
  backup false
  only_if "test -f #{DRIVER_FILE}"
end

# Remove the extracted directory.
directory DIR_NAME do
  action :delete
  recursive true
  only_if "test -d #{DIR_NAME}"
end
