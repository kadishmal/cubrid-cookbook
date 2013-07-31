site :opscode

metadata

group :integration do
  # Requirement for Ununtu testing.
  cookbook "apt"
  # Requirement for CentOS testing.
  cookbook "yum"

  cookbook 'minitest-handler'
  # This 'cubrid' cookbook should be installed to be used in cubrid_test cookbook.
  cookbook "cubrid", :path => "."
  cookbook "cubrid_test", :path => "./test/cookbooks/cubrid_test"
end