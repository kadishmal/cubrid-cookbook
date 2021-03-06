#
# Cookbook Name:: cubrid
# Metadata
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
name             "cubrid"
maintainer       "Esen Sagynov"
maintainer_email "kadishmal@gmail.com"
license          "MIT"
description      "Installs/Configures CUBRID Database"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.5.1"


depends          "build-essential"
depends          "database"
depends          "mysql"
depends          "perl"
depends          "php"
depends          "python"
depends          "yum"

%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end

# Provided recipes.
provides "cubrid::default"
provides "cubrid::broker"
provides "cubrid::demodb"
provides "cubrid::ha"
provides "cubrid::new_dbs"
provides "cubrid::pdo_cubrid"
provides "cubrid::perl_driver"
provides "cubrid::php_driver"
provides "cubrid::python_driver"
provides "cubrid::shard"
provides "cubrid::web_manager"

# Recipe descriptions.
recipe "cubrid", "Installs CUBRID Database"
recipe "cubrid::broker", "Configures additional CUBRID Brokers"
recipe "cubrid::demodb", "Installs CUBRID demodb database"
recipe "cubrid::ha", "Configures CUBRID HA in multi VM environment"
recipe "cubrid::new_dbs", "Creates multiple databases"
recipe "cubrid::pdo_cubrid", "Installs CUBRID PDO driver"
recipe "cubrid::perl_driver", "Installs CUBRID Perl driver"
recipe "cubrid::php_driver", "Installs CUBRID PHP driver"
recipe "cubrid::python_driver", "Installs CUBRID Python driver"
recipe "cubrid::shard", "Configures CUBRID SHARD in multi VM environment"
recipe "cubrid::web_manager", "Installs CUBRID Web Manager"

# Provided resources.
provides "cubrid_database"
