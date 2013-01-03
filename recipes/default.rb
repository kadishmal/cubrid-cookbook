#
# Cookbook Name:: cubrid
# Recipe:: default
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
#include_recipe "apt"

# add CUBRID Launchpad PPA
#apt_repository "cubrid" do
#  uri "http://ppa.launchpad.net/cubrid/cubrid/ubuntu/"
  # for this case, use lucid support only,
  # later it should auto detect the user OS
#  components ["lucid", "main"]
#  keyserver "keyserver.ubuntu.com"
#  key "E871ADEE"
#end

USER_HOME_DIR = "#{node['cubrid']['user_home_dir']}"
FILENAME = "#{node['cubrid']['filename']}"
CUBRID_BINARY = "#{USER_HOME_DIR}/#{FILENAME}"
CUBRID_HOME_DIR = "#{node['cubrid']['home']}"
CUBRID_DATABASES_DIR = "#{CUBRID_HOME_DIR}/databases"
ENV_SCRIPT = "#{node['cubrid']['env_script']}"

ENV['CUBRID'] = "#{CUBRID_HOME_DIR}"
ENV['CUBRID_DATABASES'] = "#{CUBRID_DATABASES_DIR}"
ENV['CUBRID_LANG'] = "en_US"
ENV['LD_LIBRARY_PATH'] = "#{CUBRID_HOME_DIR}/lib:#{ENV['LD_LIBRARY_PATH']}"
ENV['PATH'] = "#{CUBRID_HOME_DIR}/bin:#{ENV['PATH']}"

remote_file CUBRID_BINARY do
  source "#{node['cubrid']['tar_url']}"
  mode 0644
  not_if "test -d #{CUBRID_HOME_DIR}"
end

execute "extract #{CUBRID_BINARY} to #{CUBRID_HOME_DIR}" do
  user "vagrant"
  cwd "#{USER_HOME_DIR}"
  command "tar -zxf #{FILENAME}"
  not_if "test -d #{CUBRID_HOME_DIR}"
end

file "#{CUBRID_BINARY}" do
  action :delete
  not_if "test -d #{CUBRID_HOME_DIR}"
  backup false
end

execute "move CUBRID to #{CUBRID_HOME_DIR}" do
  user "root"
  cwd "#{USER_HOME_DIR}"
  command "mv CUBRID #{CUBRID_HOME_DIR}"
  not_if "test -d #{CUBRID_HOME_DIR}"
end

# Set environment variables script which will run every time a user logs in
execute "Set environment variables script" do
  user "root"
  command "cp #{node['cubrid']['env_script_original']} #{ENV_SCRIPT}"
  not_if "test -d #{ENV_SCRIPT}"
end

# start cubrid service
execute "cubrid service start" do
  user "vagrant"
end