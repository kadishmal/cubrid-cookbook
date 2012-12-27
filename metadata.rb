#
# Cookbook Name:: cubrid
# Metadata
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#
maintainer       "Esen Sagynov"
maintainer_email "kadishmal@gmail.com"
license          "MIT"
description      "Installs/Configures cubrid"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

#depends          "apt"
depends          "build-essential"
depends          "php"

%w{ ubuntu }.each do |os|
  supports os
end

recipe "cubrid", "Installs CUBRID 9.0"
recipe "pdo_cubrid", "Installs CUBRID PDO driver 9.0"
