#
# Cookbook Name:: cubrid
# Recipes:: shard_mysql
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

if node['cubrid']['version'] >= "8.4.3"
	if node['cubrid']['shard_db'] != "" && !node['cubrid']['shard_hosts'].empty?
		if node['cubrid']['shard_key_modular'] < node['cubrid']['shard_hosts'].length
			Chef::Log.warn("`shard_key_modular` is less than the number of shard. Some shard will not be used.")
		end

		SHARD_CONF = "#{node['cubrid']['shard_conf']}"
		SHARD_CONNECTION_TXT = "#{node['cubrid']['shard_connection_txt']}"
		SHARD_KEY_TXT = "#{node['cubrid']['shard_key_txt']}"

		# Get the hostname of the last node specified in the `shard_hosts` array.
		shard_broker_host = {}

		# Add host and IP information to /etc/hosts file.
		# The last of all the hosts will be the SHARD Broker node.
		node['cubrid']['shard_hosts'].each do |host_list|
			host_list.each do |host, ip|
				execute "sed -i '$a #{ip}\t#{host}' /etc/hosts" do
					not_if "egrep '\s#{host}\b' /etc/hosts"
				end

				shard_broker_host['host'] = host
				shard_broker_host['ip'] = ip
			end
		end

		# Whether or not the hostname of the current node is same as the to-be-shard node's hostname.
		# This will later be used to install CUBRID SHARD on this node or not.
		# We need to strip `hostname`, which will remove all whitespaces at the beginning or the
		# end of the string. By default, `hostname` includes a newline at the end.
		this_node_is_shard_broker = `hostname`.strip.eql? shard_broker_host['host']

		# Since in SHARD environment we need to allow the remote SHARD node to
		# access all other shard databases, make sure MySQL's bind-address is set to `0.0.0.0`.
		node.override['mysql']['bind_address'] = '0.0.0.0'
		# 28800 is the default MySQL 5.1 configuration, so return it back.
		# The reason is that CUBRID SHARD relies on this value, i.e. it assumes
		# the connection between CUBRID SHARD and MySQL is open during this period.
		# If a smaller value is set, CUBRID SHARD will report "2006:MySQL server has gone away"
		# error for the first connection established after the wait_timeout. For every next
		# connection, CUBRID SHARD will reestablish the connection and work fine.
		# So, for predictable behavior we must keep the default value.
		node.override['mysql']['tunable']['wait_timeout'] = 28800

		# Install MySQL Server and its Client tools.
		include_recipe "mysql::server"
		include_recipe "mysql::client"
		# Load database cookbook which will allow us to create MySQL databases and users.
		include_recipe "database::mysql"
		# Install CUBRID SHARD only if this machine is where CUBRID SHARD should run.
		include_recipe "cubrid" if this_node_is_shard_broker

		# The MySQL connection information for localhost.
		mysql_connection_info = {:host => 'localhost',
		 							:username => 'root',
		 							:password => node['mysql']['server_root_password']}

		# Create the SHARD database.
		mysql_database "#{node['cubrid']['shard_db']}" do
			connection mysql_connection_info
			action :create
		end

		# Create the database user for SHARD.
		mysql_database_user node['cubrid']['shard_user'] do
			connection mysql_connection_info
			password node['cubrid']['shard_user_password']
			action :create
		end

		# Grant this shard user full access to the shard database on localhost.
		mysql_database_user node['cubrid']['shard_user'] do
			connection mysql_connection_info
			password node['cubrid']['shard_user_password']
			database_name node['cubrid']['shard_db']
			action :grant
		end

		# Grant a remote SHARD node's same user full access to this shard database.
		mysql_database_user node['cubrid']['shard_user'] do
			connection mysql_connection_info
			password node['cubrid']['shard_user_password']
			host shard_broker_host['host']
			database_name node['cubrid']['shard_db']
			action :grant
		end

		# On CentOS/RedHat/Fedora iptables REJECTs all external connection to most ports including those used to connect to MySQL.
		# We need to open CUBRID Shard and MySQL ports.
		if platform?("centos", "fedora", "redhat")
		  # Detailed explanation of all ports used below can be found at http://www.cubrid.org/port_iptables_configuration.
		  execute "iptables -I INPUT 1 -p tcp -m tcp --dport #{node['cubrid']['shard_broker_port']} -j ACCEPT" do
		    only_if "test -f /sbin/iptables"
		    # Do not open CUBRID SHARD port if this machine is not for CUBRID SHARD.
		  	only_if "#{this_node_is_shard_broker}"
		  end
		  # Allow access to MySQL Server only from CUBRID SHARD machine.
		  execute "iptables -I INPUT 1 -s #{shard_broker_host['ip']} -p tcp -m tcp --dport #{node['mysql']['port']} -j ACCEPT" do
		    only_if "test -f /sbin/iptables"
		  end
		end

		# Start CUBRID SHARD service only on the last shard host which is determined to be
		# a SHARD Broker node.
		if this_node_is_shard_broker
			# Update shard.conf.
			template SHARD_CONF do
			  source "shard_mysql.shard.conf.erb"
			  not_if "cat #{SHARD_CONF} | grep 'Cookbook Name:: cubrid'"
			end

			# Update shard_connection.txt.
			template SHARD_CONNECTION_TXT do
			  source "shard_mysql.shard_connection.txt.erb"
			  not_if "cat #{SHARD_CONNECTION_TXT} | grep 'Cookbook Name:: cubrid'"
			end

			# Update shard_keys.txt.
			template SHARD_KEY_TXT do
			  source "shard_key.txt.erb"
			  not_if "cat #{SHARD_KEY_TXT} | grep 'Cookbook Name:: cubrid'"
			end

			execute "cubrid shard start"
		end
	else
		raise Chef::Exceptions::AttributeNotFound, "Please set the name of a SHARD database. Refer to \"shard_db\" attribute in /cubrid/attributes/shard.rb for the syntax."
	end
else
	raise Chef::Exceptions::ValidationFailed, "CUBRID SHARD is supported only since version 8.4.3. The specified version #{node['cubrid']['version']} does not support CUBRID SHARD."
end