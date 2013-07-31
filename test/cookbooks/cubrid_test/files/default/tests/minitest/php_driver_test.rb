# The reason we put two dots in the front of the following path is
# that the file name in `__FILE__` is interpreted as a directory.
# Therefore, we need to cd .. in order to get to the actual parent
# directory.
require File.expand_path('../support/helpers.rb', __FILE__)
include Helpers::Cubrid

TEMP_DIR = "/tmp"

describe_recipe 'cubrid::php_driver' do
  it "should create cubrid.ini PHP configuration file" do
    file(node['cubrid']['php_ext_conf']).must_exist
  end

  it "should add CUBRID PHP module to cubrid.ini PHP configuration file" do
    file = resource_for({:path => node['cubrid']['php_ext_conf']})
    assert_includes_content file, 'extension="cubrid.so"'
  end

  it "should install CUBRID PHP driver" do
    assert_sh "pecl list | grep CUBRID", "CUBRID  " << node['cubrid']['php_version'] << " stable"
  end

  it "should return the correct driver version" do
    assert_sh "php #{TEMP_DIR}/get_php_driver_version.php", node['cubrid']['php_version']
  end
end
