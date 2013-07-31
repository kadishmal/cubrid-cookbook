#
# Cookbook Name:: cubrid_test
# Recipe:: php_driver
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe 'minitest-handler'
include_recipe 'cubrid::php_driver'

TEMP_DIR = "/tmp"

# Prepare the PHP example code.
template "#{TEMP_DIR}/get_php_driver_version.php" do
  source "php_driver/get_php_driver_version.php"
end
