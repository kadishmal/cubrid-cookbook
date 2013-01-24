#
# Cookbook Name:: cubrid
# Recipe:: perl_driver
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
include_recipe "build-essential"
include_recipe "perl"
include_recipe "cubrid"

# Install the Database Independent Interface module for Perl
# which CUBRID Perl driver depends on.
cpan_module "DBI"
# Install the specific version of CUBRID Perl driver.
# Ideally we should use "DBD::cubrid" as a package name, but
# CPAN installs only the latest version of the module. So,
# in order to install the specific version of CUBRID Perl module
# we should use "authot/package_file" format instead.
cpan_module "CUBRID/#{node['cubrid']['perl_filename']}" do
  force true
end
