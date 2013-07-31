#
# Cookbook Name:: cubrid_test
# Recipe:: pdo_cubrid
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe 'minitest-handler'
include_recipe 'cubrid::pdo_cubrid'

TEMP_DIR = "/tmp"

# Prepare the PHP example code.
template "#{TEMP_DIR}/get_pdo_drivers_list.php" do
  source "pdo_cubrid/get_pdo_drivers_list.php"
end
