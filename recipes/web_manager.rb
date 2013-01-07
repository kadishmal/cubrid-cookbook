#
# Cookbook Name:: cubrid
# Recipe:: web_manager
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

include_recipe "cubrid"

if node['cubrid']['version'] != "8.4.3"
  USER_HOME_DIR = "#{node['cubrid']['user_home_dir']}"
  CWM_EXTRACT_DIR_NAME = "#{USER_HOME_DIR}/#{node['cubrid']['cwm_dirname']}"
  CWM_BINARY = "#{USER_HOME_DIR}/#{node['cubrid']['cwm_filename']}"
  CUBRID_HOME_DIR = "#{node['cubrid']['home']}"

  remote_file CWM_BINARY do
    user "vagrant"
    source "#{node['cubrid']['cwm_tar_url']}"
    mode 0644
    not_if "test -d #{CUBRID_HOME_DIR}/share/webmanager"
  end

  execute "tar -zxf #{CWM_BINARY}" do
    user "vagrant"
    cwd "#{USER_HOME_DIR}"
    only_if "test -f #{CWM_BINARY}"
  end

  # stop cubrid manager
  execute "cubrid manager stop" do
    user "vagrant"
    only_if "test -f #{CWM_BINARY}"
  end

  execute "Override CUBRID binaries" do
    user "vagrant"
    command "cp -r #{CWM_EXTRACT_DIR_NAME}/* #{CUBRID_HOME_DIR}"
    only_if "test -d #{CWM_EXTRACT_DIR_NAME}"
  end

  # start cubrid manager
  execute "cubrid manager start" do
    user "vagrant"
    only_if "test -f #{CWM_BINARY}"
  end

  directory "#{USER_HOME_DIR}/#{CWM_EXTRACT_DIR_NAME}" do
    action :delete
    recursive true
    only_if "test -d #{USER_HOME_DIR}/#{CWM_EXTRACT_DIR_NAME}"
  end

  file "#{CWM_BINARY}" do
    action :delete
    only_if "test -f #{CWM_BINARY}"
    backup false
  end
else
  log "CUBRID 8.4.3 already comes with built-in CUBRID Web Manager. So skipping this installation."
end