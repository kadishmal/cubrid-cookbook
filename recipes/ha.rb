#
# Cookbook Name:: cubrid
# Recipes:: ha
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

require 'chef/util/file_edit'

include_recipe "cubrid"

if !node['cubrid']['ha_hosts'].empty?
	CUBRID_CONF = "#{node['cubrid']['conf']}"
	HA_CONF = "#{node['cubrid']['ha_conf']}"
	DATABASES_TXT = "#{node['cubrid']['databases_dir']}/databases.txt"

	# create HA databases
	node['cubrid']['ha_db_list'].each do |db|
		cubrid_database db do
			action :create
			autostart false
		end

		ruby_block "add hosts to databases.txt for #{db} database" do
	      block do
	        databases_txt = Chef::Util::FileEdit.new("#{DATABASES_TXT}")
			databases_txt.search_file_replace(/#{db}[\t\s]+localhost/, "#{db}	#{node['cubrid']['ha_hosts_list']}")
			databases_txt.write_file
	      end
	      only_if "egrep '#{db}[\t\s]+localhost' #{DATABASES_TXT}"
	    end
	end

	# Add host and IP information to /etc/hosts file.
	node['cubrid']['ha_hosts'].each do |host, ip|
		execute "sed -i '$a #{ip} #{host}' /etc/hosts" do
			not_if "egrep '\b#{host}\b' /etc/hosts"
		end
	end

	# On CentOS/RedHat/Fedora iptables REJECTs all external connection to most ports including those used to conenct to CUBRID.
	# We need to open CUBRID HA port only.
	if platform?("centos", "fedora", "redhat")
	  # Detailed explanation of all ports used below can be found at http://www.cubrid.org/port_iptables_configuration.
	  # Port 59901 is CUBRID HA port.
	  execute "iptables -I INPUT 1 -p udp -m udp --dport 59901 -j ACCEPT" do
	    only_if "test -f /sbin/iptables"
	  end
	end

	# update cubrid_ha.conf
	template HA_CONF do
	  source "cubrid_ha.conf.erb"
	  not_if "cat #{HA_CONF} | grep 'Cookbook Name:: cubrid'"
	end

	# update cubrid.conf
	template CUBRID_CONF do
	  source "cubrid.conf.erb"
	  not_if "cat #{CUBRID_CONF} | grep 'Cookbook Name:: cubrid'"
	end

	# restart cubrid service
	execute "cubrid service restart"

	# start cubrid heartbeat
	execute "cubrid heartbeat start"
else
	raise Chef::Exceptions::AttributeNotFound, "Cannot configure CUBRID HA without ha_hosts. Refer to \"ha_hosts\" attribute in /cubrid/attributes/ha.rb for the syntax."
end
