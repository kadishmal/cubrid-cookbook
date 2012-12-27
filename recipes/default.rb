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
CUBRID_DEMODB_DIR = "#{CUBRID_DATABASES_DIR}/demodb"
ENV_SCRIPT = "#{node['cubrid']['env_script']}"

remote_file CUBRID_BINARY do
  user "vagrant"
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

# create a "demodb" directory if it doesn't exist
directory "#{CUBRID_DEMODB_DIR}" do
  user "vagrant"
  action :create
  not_if "test -d #{CUBRID_DEMODB_DIR}"
end

# install demodb database if it doesn't exist
execute "#{node['cubrid']['demodb_script']}" do
  user "vagrant"
  cwd "#{CUBRID_DEMODB_DIR}"
  environment({
    "CUBRID" => "#{CUBRID_HOME_DIR}",
    "CUBRID_DATABASES" => "#{CUBRID_DATABASES_DIR}"
  })
  not_if "test -f #{CUBRID_DEMODB_DIR}/demodb"
end

execute "cubrid service start" do
  user "vagrant"
end