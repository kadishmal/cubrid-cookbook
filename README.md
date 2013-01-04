## Description

Provides recipies to install [CUBRID Database](http://www.cubrid.org) (*version 9.0, 8.4.3, and 8.4.1*), CUBRID PDO and PHP drivers (*see [Recipies](#recipes) below*), create the [demodb](http://www.cubrid.org/wiki_tutorials/entry/getting-started-with-demodb-cubrid-demo-database) database, and automatically configure CUBRID HA environment.

This **cubrid** cookbook is tested on [Vagrant](http://www.cubrid.org/wiki_tutorials/entry/create-a-cubrid-database-vm-with-vagrant-and-chef-cookbook-under-5-minutes) boxes (*see [Platform](#platform) below*).

## Platform

Tested on:

- Ubuntu 12.04 LTS x86/x64 (Vagrant *[Ubuntu lucid 64](http://files.vagrantup.com/precise32.box)*/*[precise64](http://files.vagrantup.com/precise64.box)* boxes)
- Ubuntu 10.04 LTS x86/x64 (Vagrant *[Ubuntu lucid 32](http://files.vagrantup.com/lucid32.box)*, *[Ubuntu lucid 64](http://files.vagrantup.com/lucid64.box)* boxes)
- Ubuntu 12.04 LTS x86/x64 (Vagrant *[Ubuntu precise 32](http://files.vagrantup.com/precise32.box)*, *[Ubuntu precise 64](http://files.vagrantup.com/precise64.box)* boxes)

##Requirements

This **cubrid** cookbook has the following dependencies:

- Chef 0.10.10+. Make sure you have the latest version of Chef. [Update](http://wiki.opscode.com/display/chef/Upgrading+Chef+0.10.x+to+the+newest+version+of+Chef) if necessary.
- [build-essential](http://community.opscode.com/cookbooks/build-essential) and [php](http://community.opscode.com/cookbooks/php) cookbooks for **pdo_cubrid** and **php_driver** recipes.

## Recipes

This cookbook provides the following recipes:

- **cubrid**: installs the specified version of CUBRID Database. Available versions: 8.4.1, 8.4.3, 9.0.0  (*default*).
- **demodb**: creates CUBRID's [demodb](http://www.cubrid.org/wiki_tutorials/entry/getting-started-with-demodb-cubrid-demo-database) database.
- **ha**: configures CUBRID HA in multi VM environment.
- **php_driver**: installs [CUBRID PHP driver](http://www.cubrid.org/wiki_apis/entry/cubrid-php-driver) (*same version as CUBRID Database*).
- **pdo_cubrid**: installs [CUBRID PDO driver](http://www.cubrid.org/wiki_apis/entry/cubrid-pdo-driver) (*same version as CUBRID Database, except when CUBRID 8.4.1 is installed in which case PDO driver 8.4.0 is installed as they are compatible*).

## Attributes

### attributes/default.rb

```
# the default version of CUBRID to install
default['cubrid']['version']
# the full version of CUBRID including the build number
set['cubrid']['full_version']
# the architecture of CUBRID binaries to install based on the current system architecture
set['cubrid']['arch']

# the file name of the archive to download
set['cubrid']['filename']

# the full URL of the TAR archive to download
set['cubrid']['tar_url']

# the home directory of a Vagrant user
default['cubrid']['user_home_dir']
# the target directory to install CUBRID
default['cubrid']['home']

# the file name of the shell scipt which sets environmental variables for CUBRID
set['cubrid']['env_script_name']
# the full path of the original shell script distributed with CUBRID source
set['cubrid']['env_script_original']
# the target path where the shell script should be placed so that when a user logs in the variables are available.
set['cubrid']['env_script']
```

### attributes/database.rb

```
# the default target directory to install CUBRID
default['cubrid']['home']

# the directory to store CUBRID databases
set['cubrid']['databases_dir']

# "data_buffer_size" parameter value used in conf/cubrid.conf
default['cubrid']['data_buffer_size']
# "db_volume_size" parameter value used in conf/cubrid.conf
default['cubrid']['db_volume_size']
# "log_volume_size" parameter value used in conf/cubrid.conf
default['cubrid']['log_volume_size']
```

### attributes/demodb.rb

```
# the default target directory to install CUBRID
default['cubrid']['home']

# the directory where to install the demodb database
set['cubrid']['demodb_dir']
# the full path of a script which install the demodb database
set['cubrid']['demodb_script']
```

### attributes/ha.rb

```
# a default list of databases to create and configure for CUBRID HA
default['cubrid']['ha_dbs']
# the name of the HA group
default['cubrid']['ha_group']
# a default list of hosts to join ha_group
# in the form of { "node1" => "IP 1", "node2" => "IP 2" ... }
default['cubrid']['ha_hosts']

# ha_db_list in the form of db1,db2...
set['cubrid']['ha_db_list']
# ha_hosts_list in the form of node1:node2...
set['cubrid']['ha_hosts_list']
# ha_node_list in the form of ha_group@ha_hosts_list
set['cubrid']['ha_node_list']

# the configurations directory
set['cubrid']['conf_dir']
# full path to cubrid.conf
set['cubrid']['conf']
# full path to cubrid_ha.conf
set['cubrid']['ha_conf']
```

### attributes/new_dbs.rb

```
# a default list of databases to create
default['cubrid']['new_dbs']
```

### attributes/pdo_cubrid.rb

```
# the default version of CUBRID to install
default['cubrid']['version']

# the version of a CUBRID PDO driver to install from PECL
set['cubrid']['pdo_version']
# the name of a PECL package to install CUBRID PDO driver
set['cubrid']['pdo_package']

# the location of PHP configuration directory
set['cubrid']['php_ext_conf_dir']

# the full path of pdo_cubrid.ini
set['cubrid']['pdo_ext_conf']
# the directives which should be placed in pdo_cubrid.ini files; these are populate to pdo_cubrid.ini.erb template of this cookbook.
set['cubrid']['pdo_directives']
```

### attributes/php_driver.rb

```
# the default version of CUBRID to install
default['cubrid']['version']

# the version of a CUBRID PHP driver to install from PECL
set['cubrid']['php_version']
# the name of a PECL package to install CUBRID PHP driver
set['cubrid']['php_package']

# the location of PHP configuration directory
set['cubrid']['php_ext_conf_dir']

# the full path of cubrid.ini
set['cubrid']['php_ext_conf']
# the directives which should be placed in cubrid.ini files; these are populate to cubrid.ini.erb template of this cookbook.
set['cubrid']['php_directives']
```
## Usage

### CUBRID Database

If you want to install the *default* 9.0.0 version of CUBRID, use **default** recipe.

```
chef.add_recipe "cubrid"
```

To install another version of CUBRID like 8.4.1 or 8.4.3, override the `version` attribute in Chef JSON.

```
chef.json = {
    "cubrid" => {
        "version" => "8.4.3"
    }
}

chef.add_recipe "cubrid"
```

This will:

1. Set envrionmental vartiables for CUBRID.
2. Download the specified version of CUBRID (`tar.gz`) from [CUBRID SF.net repository](http://sourceforge.net/projects/cubrid/files/) if it is not already installed at */opt/cubrid*.
3. Extract it to */opt/cubrid*.
4. Remove the downloaded archive.
5. Setup the startup script for a user to auto set environmental variables when the user logs in to the system.
6. Start CUBRID Service.

### CUBRID demodb database

If you want to install CUBRID [demodb](http://www.cubrid.org/wiki_tutorials/entry/getting-started-with-demodb-cubrid-demo-database) database, use **demodb** recipe. This recipe depends on **cubrid::default** recipe.

```
chef.add_recipe "cubrid::demodb"
```

This will:

1. Create CUBRID's demodb database if it's not already created.
2. Auto start **demodb** database.

### CUBRID HA

If you want to have [CUBRID HA](http://www.cubrid.org/manual/843/en/CUBRID%20HA) configured for you automatically on multi VM environment, use **ha** recipe. With CUBRID HA you can have very reliable and predictable automatic failover between your database nodes.

This recipe depends on **cubrid::default** recipe.

```
chef.add_recipe "cubrid::ha"
```

This will:

1. Check if `ha_hosts` attribute is provided by a user. That is, you **must** pass a list of hosts to join CUBRID HA group. `ha_hosts` should be a hash of **host=>IP** key-values:

        chef.json = {
            "cubrid" => {
                "ha_hosts" => {"node1" => "10.11.12.13", "node2" => "10.11.12.14"}
            }
        }
        
	If `ha_hosts` is not provided, an error will be raise saying: **Cannot configure CUBRID HA without ha_hosts. Refer to "ha_hosts" attribute in /cubrid/attributes/ha.rb for the syntax.**
2. Create all databases listed in `ha_dbs` array which need to be replicated between master:slave nodes in HA environment, if they are not already created. If user doesn't override this attribute, `ha_dbs=["testdb"]`.
3. Update */opt/cubrid/databases/databases.txt* file to set `ha_hosts` for each database, if it is not already updated.
4. Update */etc/hosts* with new **IP - host** values defined in `ha_hosts`, if it is not already updated.
5. Update *conf/cubrid.conf* configuration file to turn on CUBRID HA.
6. Update *conf/cubrid_ha.conf* with new configurations for CUBRID HA.
7. Restart CUBRID Service.
8. Start [CUBRID Heartbeat](http://www.cubrid.org/manual/843/en/Utilities%20of%20cubrid%20heartbeat).

### Create new databases

If you also want to create multiple databases, use **new_dbs** recipe. This recipe depends on the **cubrid::default** recipe.

    chef.json = {
        "cubrid" => {
            "new_dbs" => ["apple_db", "banana_db"],
        }
    }
    
    chef.add_recipe "cubrid::new_dbs"


This will:

1. Create all databases defined in `new_dbs` attribute.
2. Auto start all databases.

### CUBRID PDO driver

If you want to install CUBRID PDO driver, use **pdo_cubrid** recipe. This recipe depends on the **cubrid::default** recipe.

```
chef.add_recipe "cubrid::pdo_cubrid"
```

This will:

1. Install CUBRID PDO driver from [PHP PECL Repository](http://pecl.php.net/package/PDO_CUBRID) if the PDO driver is not already installed (*same version as the previously installed CUBRID Database*).
2. Create */etc/php5/conf.d/pdo_cubrid.ini*.

**Note**: this recipe as well as **php_driver** do not restart your Web server automatically because they do not know which Web server you use. So, if necessary, restart your Web server manually.

### CUBRID PHP driver

If you also want to install CUBRID PHP driver, use **php_driver** recipe. This recipe depends on the **cubrid::default** recipe.

```
chef.add_recipe "cubrid::php_driver"
```

This will:

1. Install CUBRID PHP driver from [PHP PECL Repository](http://pecl.php.net/package/CUBRID) if it is not already installed (*same version as the previously installed CUBRID Database*).
2. Create */etc/php5/conf.d/cubrid.ini*.

## TODO

1. Test on other **Linux distributions** including Fedora and CentOS.
2. Add other **CUBRID drivers** support: Python, Perl.
3. Add [CUBRID Web Manager](http://www.cubrid.org/wiki_tools/entry/cubrid-web-manager) support.
4. Add [CUBRID Sharding](http://www.cubrid.org/blog/news/announcing-cubrid-9-0-with-3x-performance-increase-and-sharding-support/) support.

## License and Authors

- Esen Sagynov (<kadishmal@gmail.com>)

Distributed under [MIT License](http://en.wikipedia.org/wiki/MIT_License).