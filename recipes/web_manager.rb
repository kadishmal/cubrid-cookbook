#
# Cookbook Name:: cubrid
# Recipe:: web_manager
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

include_recipe "cubrid"

TEMP_DIR = "/tmp"
CWM_EXTRACT_DIR_NAME = "#{TEMP_DIR}/#{node['cubrid']['cwm_dirname']}"
CWM_BINARY = "#{TEMP_DIR}/#{node['cubrid']['cwm_filename']}"
CUBRID_HOME_DIR = "#{node['cubrid']['home']}"
CWM_HOME_DIR = "#{CUBRID_HOME_DIR}/share/webmanager"
CM_HTTPD_CONF = "#{node['cubrid']['cm_httpd_conf']}"

if node['cubrid']['version'] != "8.4.3"
  remote_file CWM_BINARY do
    action :create_if_missing
    source "#{node['cubrid']['cwm_tar_url']}"
    mode 0644
    not_if "test -d #{CWM_HOME_DIR}"
  end

  execute "tar -zxf #{CWM_BINARY}" do
    cwd "#{TEMP_DIR}"
    only_if "test -f #{CWM_BINARY}"
  end

  # stop cubrid manager
  execute "cubrid manager stop" do
    only_if "test -f #{CWM_BINARY}"
  end

  execute "Override CUBRID binaries" do
    command "cp -r #{CWM_EXTRACT_DIR_NAME}/* #{CUBRID_HOME_DIR}"
    only_if "test -d #{CWM_EXTRACT_DIR_NAME}"
  end

  # Own CUBRID files.
  execute "Change ownership of #{CUBRID_HOME_DIR}" do
    command "chown -R root #{CUBRID_HOME_DIR} && chgrp -R root #{CUBRID_HOME_DIR}"
    only_if "test -d #{CUBRID_HOME_DIR}"
    not_if "ls -ld #{CWM_HOME_DIR} | grep root"
  end

  directory "#{CWM_EXTRACT_DIR_NAME}" do
    action :delete
    recursive true
    only_if "test -d #{CWM_EXTRACT_DIR_NAME}"
  end

  file "#{CWM_BINARY}" do
    action :delete
    only_if "test -f #{CWM_BINARY}"
    backup false
  end
end

# Stop CUBRID Manager Service.
execute "cubrid manager stop"

# Update cm_httpd.conf.
template CM_HTTPD_CONF do
  source "cm_httpd.conf.erb"
  not_if "cat #{CM_HTTPD_CONF} | grep 'Cookbook Name:: cubrid'"
end

# Start CUBRID Manager Service.
execute "cubrid manager start"

# On CentOS/RedHat/Fedora iptables REJECTs all external connection to most ports including those used to conenct to CUBRID.
# We need to open CUBRID Web Manager port only.
if platform?("centos", "fedora", "redhat")
  # Detailed explanation of all ports used below can be found at http://www.cubrid.org/port_iptables_configuration.
  # Port 8282 is the default HTTPS port used by CUBRID Web Manager.
  execute "iptables -I INPUT 1 -p tcp -m tcp --dport 8282 -j ACCEPT" do
    only_if {File.exists?("/sbin/iptables") && File.directory?("#{CWM_HOME_DIR}")}
  end
end
