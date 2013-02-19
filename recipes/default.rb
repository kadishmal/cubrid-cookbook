#
# Cookbook Name:: cubrid
# Recipe:: default
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

# add CUBRID Launchpad PPA
#apt_repository "cubrid" do
#  uri "http://ppa.launchpad.net/cubrid/cubrid/ubuntu/"
  # for this case, use lucid support only,
  # later it should auto detect the user OS
#  components ["lucid", "main"]
#  keyserver "keyserver.ubuntu.com"
#  key "E871ADEE"
#end

FILENAME = "#{node['cubrid']['filename']}"
TEMP_DIR = "/tmp"
CUBRID_BINARY = "#{TEMP_DIR}/#{FILENAME}"
CUBRID_HOME_DIR = "#{node['cubrid']['home']}"
CUBRID_DATABASES_DIR = "#{CUBRID_HOME_DIR}/databases"
CUBRID_CONF = "#{node['cubrid']['conf']}"
ENV_SCRIPT = "#{node['cubrid']['env_script']}"

ENV['CUBRID'] = "#{CUBRID_HOME_DIR}"
ENV['CUBRID_DATABASES'] = "#{CUBRID_DATABASES_DIR}"
ENV['CUBRID_LANG'] = "en_US"
ENV['LD_LIBRARY_PATH'] = "#{CUBRID_HOME_DIR}/lib:#{ENV['LD_LIBRARY_PATH']}"
ENV['PATH'] = "#{CUBRID_HOME_DIR}/bin:#{ENV['PATH']}"

# Download the archive.
remote_file CUBRID_BINARY do
  action :create_if_missing
  source "#{node['cubrid']['tar_url']}"
  mode 0644
  not_if "test -d #{CUBRID_HOME_DIR}"
end

# Extract the downloaded archive.
execute "tar -zxf #{FILENAME}" do
  cwd "#{TEMP_DIR}"
  only_if "test -f #{CUBRID_BINARY}"
end

# Move the extracted directory to the target CUBRID home directory.
execute "mv CUBRID #{CUBRID_HOME_DIR}" do
  cwd "#{TEMP_DIR}"
  not_if "test -d #{CUBRID_HOME_DIR}"
  only_if "test -d #{TEMP_DIR}/CUBRID"
end

# Own CUBRID files.
execute "Change ownership of #{CUBRID_HOME_DIR}" do
  command "chown -R root #{CUBRID_HOME_DIR} && chgrp -R root #{CUBRID_HOME_DIR}"
  only_if "test -d #{CUBRID_HOME_DIR}"
  not_if "ls -ld #{CUBRID_HOME_DIR} | grep root"
end

# Remove the downloaded archive.
file "#{CUBRID_BINARY}" do
  action :delete
  backup false
  only_if "test -f #{CUBRID_BINARY}"
end

# Set environment variables script which will run every time a user logs in
execute "Set environment variables script" do
  command "cp #{node['cubrid']['env_script_original']} #{ENV_SCRIPT}"
  not_if "test -f #{ENV_SCRIPT}"
end

# update cubrid.conf
template CUBRID_CONF do
  source "default.cubrid.conf.erb"
  not_if "cat #{CUBRID_CONF} | grep 'Cookbook Name:: cubrid'"
end

# Start CUBRID Service.
execute "cubrid service start"

# On CentOS/RedHat/Fedora iptables REJECTs all external connection to most ports including those used to conenct to CUBRID.
# We need to open CUBRID-only ports.
if platform?("centos", "fedora", "redhat")
  # Detailed explanation of all ports used below can be found at http://www.cubrid.org/port_iptables_configuration.
  # Port 1523 is for CUBRID Master process.
  execute "iptables -I INPUT 1 -p tcp -m tcp --dport 1523 -j ACCEPT" do
    only_if "test -f /sbin/iptables"
  end
  # Ports 30000 through 30100 can be used if configured to connect to CUBRID Broker.
  execute "iptables -I INPUT 1 -p tcp -m tcp --dport 30000:30100 -j ACCEPT" do
    only_if "test -f /sbin/iptables"
  end
  # Ports 33000 through 33100 can be used if configured to connect to CUBRID Broker.
  execute "iptables -I INPUT 1 -p tcp -m tcp --dport 33000:33100 -j ACCEPT" do
    only_if "test -f /sbin/iptables"
  end
  # Ports 8001 and 8002 are used to connect to CUBRID Manager Server by CUBRID Tools like CUBRID Manager or CUBRID Query Browser.
  execute "iptables -I INPUT 1 -p tcp -m tcp --dport 8001:8003 -j ACCEPT" do
    only_if "test -f /sbin/iptables"
  end
end
