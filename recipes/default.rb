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
  execute "iptables -I INPUT 1 -p tcp -m tcp --dport 8001:8002 -j ACCEPT" do
    only_if "test -f /sbin/iptables"
  end
end
