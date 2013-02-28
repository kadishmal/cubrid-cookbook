#
# Cookbook Name:: cubrid
# Provider:: database
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

action :create do
  DB = "#{new_resource.name}"
  DIR = "#{node['cubrid']['databases_dir']}/#{DB}"
  LOG_DIR = "#{DIR}/log"

  # create a directory for this database
  directory "#{DIR}" do
    not_if "test -d #{DIR}"
  end

  # create a directory to store database logs
  directory "#{LOG_DIR}" do
    not_if "test -d #{LOG_DIR}"
  end

  # create this new database
  execute "cubrid createdb \
            --db-volume-size=#{node['cubrid']['db_volume_size']} \
            --log-volume-size=#{node['cubrid']['log_volume_size']} \
            --log-path=#{LOG_DIR} \
            #{DB}" do
    cwd "#{DIR}"
    not_if "test -f #{DIR}/#{DB}"
  end

  # Add a new database user or set a password.
  if new_resource.dbuser == "dba" || new_resource.dbuser == ""
    # By default "dba" use has no password. But you can set one.
    # Check if the user has set a password.
    if new_resource.password != ""
      # Make sure the database is stopped. It may be started if it was
      # already created, eg. by "demodb" recipe.
      execute "cubrid server stop #{DB}"
      # Change the password.
      execute "Change a user password for \"dba\" user in #{DB} database." do
        command "csql -S -u dba #{DB} -c \"ALTER USER dba PASSWORD '#{new_resource.password}'\""
        only_if "csql -S -u dba #{DB} -c \"SELECT 1 FROM db_root\""
      end
    end
  else
    # "dba" is a default user for any database. But user can add more users.
    # Check if the user has set a password.
    if new_resource.password != ""
      # Make sure the database is stopped. It may be started if it was
      # already created, eg. by "demodb" recipe.
      execute "cubrid server stop #{DB}"
      # Create a new user.
      execute "Change a user password for \"#{new_resource.dbuser}\" user in #{DB} database." do
        command "csql -S -u dba #{DB} -c \"CREATE USER #{new_resource.dbuser} PASSWORD '#{new_resource.password}'\""
        only_if "csql -S -u dba #{DB} -c \"SELECT * FROM db_user WHERE STRCMP(\"name\", '#{new_resource.dbuser}') = 0;\" | grep 'no results'"
      end
    end
  end

  if new_resource.autostart
    # Start this database.
    execute "cubrid server start #{DB}"
    # TODO: also update the cubrid.conf and set this database to be autostarted in the "server" parameter.
  end
end
