#
# Cookbook Name:: cubrid
# Resources:: database
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

actions :create
# If no action is specified, it will "create" a new database
# if it doesn't already exist.
default_action :create

# The name of a database to create.
# TODO: add :regex to validate the name of a new database.
attribute :name, :kind_of => String, :name_attribute => true
# By default the newly created database will be started automatically.
attribute :autostart, :kind_of => [TrueClass, FalseClass], :default => true
# The default user of a database is "dba" with an empty password.
# This user has full rights.
# If you assign a new value for this attribute, a new user with this
# name will be created in addition to the default "dba" user.
attribute :dbuser, :kind_of => String, :default => "dba"
# If the "password" attribute is defined along with a new username,
# this password will be assigned to a new user.
# If password is defined without "user" attribute, the password
# will be set to "dba" user, which by default has no password.
attribute :password, :kind_of => String, :default => ""
