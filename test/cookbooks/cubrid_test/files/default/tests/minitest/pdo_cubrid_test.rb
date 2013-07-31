# The reason we put two dots in the front of the following path is
# that the file name in `__FILE__` is interpreted as a directory.
# Therefore, we need to cd .. in order to get to the actual parent
# directory.
require File.expand_path('../support/helpers.rb', __FILE__)
include Helpers::Cubrid

TEMP_DIR = "/tmp"

describe_recipe 'cubrid::pdo_cubrid' do
  it "should create pdo_cubrid.ini PHP configuration file" do
    file(node['cubrid']['pdo_ext_conf']).must_exist
  end

  it "should add CUBRID PHP module to pdo_cubrid.ini PHP configuration file" do
    file = resource_for({:path => node['cubrid']['pdo_ext_conf']})
    assert_includes_content file, 'extension="pdo_cubrid.so"'
  end

  it "should install CUBRID PDO driver" do
    assert_sh "pecl list | grep PDO_CUBRID", "PDO_CUBRID  " << node['cubrid']['pdo_version'] << " stable"
  end

  it "should succeed to load the PDO driver" do
    assert_sh "php #{TEMP_DIR}/get_pdo_drivers_list.php | grep cubrid", "cubrid"
  end
end
