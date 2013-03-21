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
		SHARD_CONF = "#{node['cubrid']['shard_conf']}"
		SHARD_CONNECTION_TXT = "#{node['cubrid']['shard_connection_txt']}"
		SHARD_KEY_TXT = "#{node['cubrid']['shard_key_txt']}"

		last_host_to_be_shard_broker = ""

		# Add host and IP information to /etc/hosts file.
		# The last of all the hosts will be the SHARD Broker node.
		node['cubrid']['shard_hosts'].each do |host_list|
			host_list.each do |host, ip|
				execute "sed -i '$a #{ip}\t#{host}' /etc/hosts" do
					not_if "egrep '\s#{host}\b' /etc/hosts"
				end

				last_host_to_be_shard_broker = host
			end
		end

		# Since in SHARD environment we need to allow the remote SHARD node to
		# access all other shard databases, make sure MySQL's bind-address is not set.
		node.override['mysql']['bind_address'] = ''
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
		# Now install CUBRID which comes with CUBRID SHARD.
		include_recipe "cubrid"

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
			host last_host_to_be_shard_broker
			database_name node['cubrid']['shard_db']
			action :grant
		end

		# On CentOS/RedHat/Fedora iptables REJECTs all external connection to most ports including those used to connect to MySQL.
		# We need to open CUBRID Shard and MySQL ports.
		if platform?("centos", "fedora", "redhat")
		  # Detailed explanation of all ports used below can be found at http://www.cubrid.org/port_iptables_configuration.
		  # Port 59901 is CUBRID HA port.
		  execute "iptables -I INPUT 1 -p tcp -m tcp --dport #{node['cubrid']['shard_broker_port']} -j ACCEPT" do
		    only_if "test -f /sbin/iptables"
		  end
		  execute "iptables -I INPUT 1 -p tcp -m tcp --dport #{node['mysql']['port']} -j ACCEPT" do
		    only_if "test -f /sbin/iptables"
		  end
		end

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

		# Start CUBRID SHARD service only on the last shard host which is determined to be
		# a SHARD Broker node.
		execute "cubrid shard start" do
		  only_if "hostname | grep '#{last_host_to_be_shard_broker}'"
		end
	else
		raise Chef::Exceptions::AttributeNotFound, "Please set the name of a SHARD database. Refer to \"shard_db\" attribute in /cubrid/attributes/shard.rb for the syntax."
	end
else
	raise Chef::Exceptions::ValidationFailed, "CUBRID SHARD is supported only since version 8.4.3. The specified version #{node['cubrid']['version']} does not support CUBRID SHARD."
end