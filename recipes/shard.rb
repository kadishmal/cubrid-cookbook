#
# Cookbook Name:: cubrid
# Recipes:: shard
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

include_recipe "cubrid"

if node['cubrid']['version'] >= "8.4.3"
	if node['cubrid']['shard_db'] != "" && !node['cubrid']['shard_hosts'].empty?
		if node['cubrid']['shard_key_modular'] < node['cubrid']['shard_hosts'].length
			Chef::Log.warn("`shard_key_modular` is less than the number of shard. Some shard will not be used.")
		end

		CUBRID_CONF = "#{node['cubrid']['conf']}"
		SHARD_CONF = "#{node['cubrid']['shard_conf']}"
		SHARD_CONNECTION_TXT = "#{node['cubrid']['shard_connection_txt']}"
		SHARD_KEY_TXT = "#{node['cubrid']['shard_key_txt']}"

		# Create the SHARD database
		cubrid_database "#{node['cubrid']['shard_db']}" do
			action :create
			# Create a new user for this database.
			dbuser "#{node['cubrid']['shard_user']}"
			password "#{node['cubrid']['shard_user_password']}"
		end

		last_host_to_be_shard_broker = ""

		# Add host and IP information to /etc/hosts file.
		node['cubrid']['shard_hosts'].each do |host_list|
			host_list.each do |host, ip|
				execute "sed -i '$a #{ip}\t#{host}' /etc/hosts" do
					not_if "egrep '\s#{host}\b' /etc/hosts"
				end

				last_host_to_be_shard_broker = host
			end
		end

		# On CentOS/RedHat/Fedora iptables REJECTs all external connection to most ports including those used to conenct to CUBRID.
		# We need to open CUBRID Shard port only.
		if platform?("centos", "fedora", "redhat")
		  # Detailed explanation of all ports used below can be found at http://www.cubrid.org/port_iptables_configuration.
		  # Port 59901 is CUBRID HA port.
		  execute "iptables -I INPUT 1 -p tcp -m tcp --dport #{node['cubrid']['shard_broker_port']} -j ACCEPT" do
		    only_if "test -f /sbin/iptables"
		  end
		end

		# Update shard.conf.
		template SHARD_CONF do
		  source "shard.conf.erb"
		  not_if "cat #{SHARD_CONF} | grep 'Cookbook Name:: cubrid'"
		end

		# Update shard_connection.txt.
		template SHARD_CONNECTION_TXT do
		  source "shard_connection.txt.erb"
		  not_if "cat #{SHARD_CONNECTION_TXT} | grep 'Cookbook Name:: cubrid'"
		end

		# Update shard_keys.txt.
		template SHARD_KEY_TXT do
		  source "shard_key.txt.erb"
		  not_if "cat #{SHARD_KEY_TXT} | grep 'Cookbook Name:: cubrid'"
		end

		execute "echo #{last_host_to_be_shard_broker}"

		# Start CUBRID SHARD service
		execute "cubrid shard start" do
		  only_if "hostname | grep '#{last_host_to_be_shard_broker}'"
		end
	else
		raise Chef::Exceptions::AttributeNotFound, "Please set the name of a SHARD database. Refer to \"shard_db\" attribute in /cubrid/attributes/shard.rb for the syntax."
	end
else
	raise Chef::Exceptions::ValidationFailed, "CUBRID SHARD is supported only since version 8.4.3. The specified version #{node['cubrid']['version']} does not support CUBRID SHARD."
end