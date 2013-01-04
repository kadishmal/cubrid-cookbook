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
    user "vagrant"
    action :create
    not_if "test -d #{DIR}"
  end

  # create a directory to store database logs
  directory "#{LOG_DIR}" do
    user "vagrant"
    action :create
    not_if "test -d #{LOG_DIR}"
  end

  # create this new database
  execute "cubrid createdb \
            --db-volume-size=#{node['cubrid']['db_volume_size']} \
            --log-volume-size=#{node['cubrid']['log_volume_size']} \
            --log-path=#{LOG_DIR} \
            #{DB}" do
    user "vagrant"
    cwd "#{DIR}"
    not_if "test -f #{DIR}/#{DB}"
  end

  if new_resource.autostart
    # start this database
    execute "cubrid server start #{DB}" do
      user "vagrant"
    end
  end
end
