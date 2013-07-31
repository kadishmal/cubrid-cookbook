name             'cubrid_test'
maintainer       "Esen Sagynov"
maintainer_email "kadishmal@gmail.com"
license          "MIT"
description      'Installs and configures a cubrid_test cookbook to test "cubrid" cookbook.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends "cubrid"
depends "minitest-handler"
