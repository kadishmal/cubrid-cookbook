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
CUBRID_HOME_DIR = node['cubrid']['home']
CWM_HOME_DIR = "#{CUBRID_HOME_DIR}/share/webmanager"
CM_HTTPD_CONF = "#{node['cubrid']['cm_httpd_conf']}"

# Stop CUBRID Manager Service.
execute "cubrid manager stop"

# I had to wrap version checking into a `ruby_block` because of
# http://tickets.opscode.com/browse/MIXLIB-11 feature: file read
# operations are run at compile time, not at execution time. This
# means that CWM files don't exist at compile time which would
# always report as if CWM is not installed.
# Wrapping in `ruby_block` tells Chef to do file read operations
# at run time.
ruby_block "Check if CURBID Web Manager needs installation" do
  block do
    version = ""

    if File.exists?("#{CWM_HOME_DIR}/appLoader.js")
      # Read the CWM version from file.
      f = File.open("#{CWM_HOME_DIR}/appLoader.js")

      pattern = /Ext\.cwm\.prodVersion = '(\d+\.\d+\.\d+\.\d+)'/

      f.each {|line|
        if match = pattern.match(line)
          version = match[1]
          break
        end
      }

      f.close
    end

    # Check if the installed version of CUBRID Web Manager is smaller
    # than the one defined in the recipe attributes.
    # Also make sure the compatible version is installed, so that
    # 9.0.0 version doesn't override 8.4.1 version.
    if version.length == 0 || version < node['cubrid']['cwm_full_version'] && version.index(node['cubrid']['cwm_major_version']) == 0
      # Since it is not possible to call Chef providers from within `ruby_block`,
      # I need to take them out of `ruby_block` and call them when necessary
      # via `recources` function.
      resources(:remote_file => CWM_BINARY).run_action(:create_if_missing)
      resources(:execute => "extract #{CWM_BINARY}").run_action(:run)
      resources(:execute => "Override CUBRID binaries").run_action(:run)
      resources(:execute => "Change ownership of #{CUBRID_HOME_DIR}").run_action(:run)
      resources(:directory => CWM_EXTRACT_DIR_NAME).run_action(:delete)
      resources(:file => CWM_BINARY).run_action(:delete)
    end
  end
end

# Do nothing unless told otherwise in the above `ruby_block`.
remote_file CWM_BINARY do
  source "#{node['cubrid']['cwm_tar_url']}"
  mode 0644
  action :nothing
end

# Do nothing unless told otherwise in the above `ruby_block`.
execute "extract #{CWM_BINARY}" do
  command "tar -zxf #{CWM_BINARY}"
  cwd "#{TEMP_DIR}"
  only_if "test -f #{CWM_BINARY}"
  action :nothing
end

# Do nothing unless told otherwise in the above `ruby_block`.
execute "Override CUBRID binaries" do
  command "cp -r #{CWM_EXTRACT_DIR_NAME}/* #{CUBRID_HOME_DIR}"
  only_if "test -d #{CWM_EXTRACT_DIR_NAME}"
  action :nothing
end

# Own CUBRID files.
# Do nothing unless told otherwise in the above `ruby_block`.
execute "Change ownership of #{CUBRID_HOME_DIR}" do
  command "chown -R root #{CUBRID_HOME_DIR} && chgrp -R root #{CUBRID_HOME_DIR}"
  only_if "test -d #{CUBRID_HOME_DIR}"
  not_if "ls -ld #{CWM_HOME_DIR} | grep root"
  action :nothing
end

# Do nothing unless told otherwise in the above `ruby_block`.
directory CWM_EXTRACT_DIR_NAME do
  recursive true
  only_if "test -d #{CWM_EXTRACT_DIR_NAME}"
  action :nothing
end

# Do nothing unless told otherwise in the above `ruby_block`.
file CWM_BINARY do
  only_if "test -f #{CWM_BINARY}"
  backup false
  action :nothing
end

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
    only_if {File.exists?("/sbin/iptables") && File.directory?(CWM_HOME_DIR)}
  end
end
