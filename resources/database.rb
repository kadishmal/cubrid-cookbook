#
# Cookbook Name:: cubrid
# Resources:: database
#
# Copyright 2012, Esen Sagynov <kadishmal@gmail.com>
#
# Distributed under MIT license
#

actions :create

default_action :create

# add :regex to validate the name of a new database
attribute :name, :kind_of => String, :name_attribute => true
