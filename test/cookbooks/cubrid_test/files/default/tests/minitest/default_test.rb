# The reason we put two dots in the front of the following path is
# that the file name in `__FILE__` is interpreted as a directory.
# Therefore, we need to cd .. in order to get to the actual parent
# directory.
require File.expand_path('../support/helpers.rb', __FILE__)
include Helpers::Cubrid

describe_recipe 'cubrid::default' do
	# Make sure the target CUBRID home directory is created.
  it "should create CUBRID_HOME directory" do
    directory(node['cubrid']['home']).must_exist.with(:owner, "root").and(:group, "root").and(:mode, "755")
  end

  it "should create an environment script file" do
    file(node['cubrid']['env_script']).must_exist
  end

  it "should override the CUBRID configuration file" do
    file(node['cubrid']['conf']).must_exist
  end

  it "should override the CUBRID configuration file with a specific content" do
    file = resource_for({:path => node['cubrid']['conf']})
    assert_includes_content file, "Cookbook Name:: cubrid"
  end

  it "should override the CUBRID Broker configuration file" do
    file(node['cubrid']['broker_conf']).must_exist
  end

  it "should override the CUBRID Broker configuration file with a specific content" do
    file = resource_for({:path => node['cubrid']['broker_conf']})
    assert_includes_content file, "Cookbook Name:: cubrid"
  end

  it "should override the CUBRID HTTPD Server configuration file" do
    file(node['cubrid']['cm_httpd_conf']).must_exist
  end

  it "should override the CUBRID HTTPD Server configuration file with a specific content" do
    file = resource_for({:path => node['cubrid']['cm_httpd_conf']})
    assert_includes_content file, "Cookbook Name:: cubrid"
  end

  # The following assertion fails on CentOS. Reported to
  # https://github.com/calavera/minitest-chef-handler/issues/66.
  # Will wait until a solution is found.
  #it "should start CUBRID Service" do
  #  service('cub_master').must_be_running
  #end
end