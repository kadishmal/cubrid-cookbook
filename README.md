## Description

Provides recipies to:

- install [CUBRID Database](http://www.cubrid.org) (*version 9.1, 9.0, 8.4.3, and 8.4.1*), CUBRID PDO, PHP, Perl, and Python drivers (*see [Recipies](#recipes) below*), as well as [CUBRID Web Manager](http://www.cubrid.org/wiki_tools/entry/cubrid-web-manager);
- create the [demodb](http://www.cubrid.org/wiki_tutorials/entry/getting-started-with-demodb-cubrid-demo-database) or any number of other user defined databases;
- automatically configure CUBRID HA and [CUBRID SHARD](http://www.cubrid.org/blog/news/announcing-cubrid-9-0-with-3x-performance-increase-and-sharding-support/) in multi VM environment;
- CUBRID SHARD can be configured with both CUBRID and MySQL backends.
- configure additional brokers.

This **cubrid** cookbook is tested on [Vagrant](http://www.vagrantup.com/) boxes as well as plain vanilla Linux (*see [Platform](#platform) below*).

For those familiar with Vagrant, the following tutorials will help you to quickly get up and running with **cubrid** cookbook:

- [Create a CUBRID Database VM with Vagrant and Chef Cookbook under 5 minutes](http://www.cubrid.org/wiki_tutorials/entry/create-a-cubrid-database-vm-with-vagrant-and-chef-cookbook-under-5-minutes)
- [Configure CUBRID HA with Vagrant and Chef Cookbook under 4 minutes](http://www.cubrid.org/wiki_tutorials/entry/configure-cubrid-ha-with-vagrant-and-chef-cookbook-under-4-minutes)
- [Configure CUBRID SHARD with Vagrant and Chef Cookbook under 2 minutes](http://www.cubrid.org/wiki_tutorials/entry/configure-cubrid-shard-with-vagrant-and-chef-cookbook-under-2-minutes)
- [Install CUBRID remotely with knife-solo and Chef Cookbook](http://www.cubrid.org/wiki_tutorials/entry/install-cubrid-remotely-with-knife-solo-and-chef-cookbook)

## Platform

Tested on:

- Ubuntu 10.04 LTS x86/x64
	- Vagrant boxes: *[Ubuntu lucid 32](http://files.vagrantup.com/lucid32.box)* (261MB), *[Ubuntu lucid 64](http://files.vagrantup.com/lucid64.box)* (280MB)
- Ubuntu 12.04 LTS x86/x64
	- Official Ubuntu Image: *[Ubuntu 12.04.1 LTS](http://releases.ubuntu.com/precise/ubuntu-12.04.1-server-amd64.iso)* (657MB)
	- Vagrant boxes: *[Ubuntu precise 32](http://files.vagrantup.com/precise32.box)* (299MB), *[Ubuntu precise 64](http://files.vagrantup.com/precise64.box)* (323MB)
- Ubuntu 13.04 LTS x86/x64
	- Official Ubuntu Vagrant box: *[Ubuntu raring 64](http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-vagrant-amd64-disk1.box)* (295MB)
- CentOS 5.6 x64
	- Vagrant box: *[CentOS 5.6 minimal](http://ftp.cubrid.org/CUBRID_VMImages/Vagrant/vagrant-virtualbox-centos-5.6-x64-minimal.box)* (240MB)
- CentOS 6.0 x64
	- Vagrant box: *[CentOS 6.0 minimal](http://dl.dropbox.com/u/9227672/CentOS-6.0-x86_64-netboot-4.1.6.box)* (362MB)
- CentOS 6.3 x64
	- Vagrant box: *[CentOS 6.3 minimal](http://sourceforge.net/projects/cubrid/files/CUBRID-Demo-Virtual-Machines/Vagrant/vagrant-virtualbox-centos-6.3-x64-minimal.box/download)* (296MB)
- CentOS 6.4 x86/x64
	- Vagrant boxes: *[CentOS 6.4 x86 minimal](http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130427.box)* (416MB), *[CentOS 6.4 x64 minimal](http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box)* (442MB)

**Note:** in order to use MySQL database sharding with CUBRID SHARD through **shard_mysql** recipe, CentOS 5.6~6.3 or Ubuntu 10.x is required as they provide MySQL 5.1. Ubuntu 12.04+ has remove MySQL 5.1 from their repositories. Support for MySQL 5.5 in **shard_mysql** recipe will be implemented soon.

##Requirements

This **cubrid** cookbook has the following dependencies:

- Chef 10.14.0+. Make sure you have the latest version of Chef. If necessary, [update](http://wiki.opscode.com/display/chef/Upgrading+Chef+0.10.x+to+the+newest+version+of+Chef) by executing `sudo gem update chef --no-ri --no-rdoc`.
- Ohai 6.14.0+. Make sure you have the latest version of Ohai. If necessary, [update](http://wiki.opscode.com/display/chef/Ohai+Installation+and+Use) by executing `sudo gem update ohai --no-ri --no-rdoc`.
- **pdo_cubrid** and **php_driver** depend on: [php](https://github.com/opscode-cookbooks/php) cookbook.
- **perl_driver** depends on: [build-essential](https://github.com/opscode-cookbooks/build-essential) and [perl](https://github.com/opscode-cookbooks/perl) cookbooks.
- **python_driver** depends on: [build-essential](https://github.com/opscode-cookbooks/build-essential) and [python](https://github.com/opscode-cookbooks/python) cookbooks.
- **shard_mysql** depends on: [mysql](https://github.com/opscode-cookbooks/mysql) and [database](https://github.com/opscode-cookbooks/database) cookbooks.

## Recipes

**cubrid** cookbook provides the following recipes:

- [broker](#cubridbroker): configures additional [CUBRID Brokers](http://www.cubrid.org/blog/cubrid-life/the-cubrid-broker-story/).
- [default](#cubriddatabase): installs the specified version of CUBRID Database. Available versions: 8.4.1, 8.4.3, 9.0.0  (*default*).
- [demodb](#cubriddemodbdatabase): creates CUBRID's [demodb](http://www.cubrid.org/wiki_tutorials/entry/getting-started-with-demodb-cubrid-demo-database) database.
- [ha](#cubridha): configures CUBRID HA in multi VM environment.
- [new_dbs](#createnewdatabases): create one or more databases defined by a user.
- [pdo_cubrid](#cubridpdodriver): installs [CUBRID PDO driver](http://www.cubrid.org/wiki_apis/entry/cubrid-pdo-driver) (*same version as CUBRID Database, except when CUBRID 8.4.1 is installed in which case PDO driver 8.4.0 is installed as they are compatible*).
- [perl_driver](#cubridperldriver): installs [CUBRID Perl driver](http://www.cubrid.org/wiki_apis/entry/cubrid-perl-driver) (*same version as CUBRID Database*).
- [php_driver](#cubridphpdriver): installs [CUBRID PHP driver](http://www.cubrid.org/wiki_apis/entry/cubrid-php-driver) (*same version as CUBRID Database*).
- [python_driver](#cubridpythondriver): installs [CUBRID Python driver](http://www.cubrid.org/wiki_apis/entry/cubrid-python-driver) (*same version as CUBRID Database*). On CentOS/RedHat < 6, the Python driver is installed from source. On other platforms, it is installed from pip.
- [python_driver_pip](#python_driver_pip): installs [CUBRID Python driver](http://www.cubrid.org/wiki_apis/entry/cubrid-python-driver) from pip.
- [python_driver_source](#python_driver_source): installs [CUBRID Python driver](http://www.cubrid.org/wiki_apis/entry/cubrid-python-driver) from source.
- [shard](#cubridshard): configures [CUBRID SHARD](http://www.cubrid.org/blog/news/announcing-cubrid-9-0-with-3x-performance-increase-and-sharding-support/) in multi VM environment.
- [shard_mysql](#mysqldatabaseshardingviacubridshard): configures MySQL as a backend database for [CUBRID SHARD](http://www.cubrid.org/blog/news/announcing-cubrid-9-0-with-3x-performance-increase-and-sharding-support/) in multi VM environment.
- [web_manager](#cubridwebmanager): installs [CUBRID Web Manager](http://www.cubrid.org/wiki_tools/entry/cubrid-web-manager).

## Attributes

Check the source code of the available attributes. All attributes are extensively commented.

- [broker](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/broker.rb)
- [database](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/database.rb)
- [default](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/default.rb)
- [demodb](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/demodb.rb)
- [ha](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/ha.rb)
- [new_dbs](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/new_dbs.rb)
- [pdo_cubrid](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/pdo_cubrid.rb)
- [perl_driver](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/perl_driver.rb)
- [php_driver](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/php_driver.rb)
- [python_driver](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/python_driver.rb)
- [shard](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/shard.rb)
- [web_manager](https://github.com/kadishmal/cubrid-cookbook/blob/master/attributes/web_manager.rb)

## Usage

### CUBRID Broker

If you want to configure additional Brokers, use **broker** recipe.

```
chef.json = {
    "cubrid" => {
        "broker_count" => 1,
        "min_num_appl_server" => 5,
        "max_num_appl_server" => 40
    }
}

chef.add_recipe "cubrid::broker"
```

This will:

1. Add specified number of CUBRID Brokers and set [`MIN_NUM_APPL_SERVER`](http://www.cubrid.org/manual/843/en/Parameter%20by%20Broker) and [`MAX_NUM_APPL_SERVER`](http://www.cubrid.org/manual/843/en/Parameter%20by%20Broker) parameters to each broker in Broker configuration file (*[cubrid_broker.conf](http://www.cubrid.org/manual/843/en/cubrid_broker.conf%20Configuration%20File%20and%20Default%20Parameters)*).
2. Restart the CUBRID Broker Service if the configuration file has been updated.

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
6. Override CUBRID configuration file (*cubrid.conf*) with user defined or default values.
7. Start CUBRID Service.
8. When installed on CentOS, this **default** recipe will auto configure the **iptables** firewall if *iptables* is installed. When *iptables* is installed, by default it `REJECT`'s all incoming connections. The **default** recipe will add `ACCEPT` rules for CUBRID ports (*but not all; HA port will be opened by **ha** recipe, Web Manager port by **web_manager** recipe, SHARD port by **shard** recipe*) such as **30000:30100**, **33000:33100**, **8001:8003**, **1523**. Detailed explanation of all ports used by CUBRID can be found at [http://www.cubrid.org/port_iptables_configuration](http://www.cubrid.org/port_iptables_configuration).

**Note:** the **cubrid** cookbook will be installed by **root** user. For this reason in order to work with CUBRID once installed, you need to be logged in as a **root**. To login as a root, run the following command:

    sudo su -

Then run any cubrid command such as:

    cubrid service status


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
9. When installed on CentOS, this **ha** recipe will auto configure the **iptables** firewall if *iptables* is installed. When *iptables* is installed, by default it `REJECT`'s all incoming connections. The **ha** recipe will add an `ACCEPT` rule for CUBRID HA port which is **59901** by default.

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
2. Optionally add a new database user with a defined username and a password. If a password is defined without a username, the password will be set for the default **dba** user, in case **dba**'s password is still empty. If the password is non-empty, i.e. has already altered previously, the password will not be reset.
2. Auto start all databases if they are set to auto start, which is the default behavior.

### CUBRID PDO driver

If you want to install CUBRID PDO driver, use **pdo_cubrid** recipe.

#### Dependencies

- [php](https://github.com/opscode-cookbooks/php) cookbook
- if you want to install the PDO driver < v9.1.0, the **cubrid::default** recipe is also required since earlier version require CUBRID to be installed to access the CCI library. Since CUBRID PDO 9.1.0.0003, CCI library is included in PDO driver source code, so doesn't require CUBRID to be installed.

#### Usage

```
chef.add_recipe "cubrid::pdo_cubrid"
```

This will:

1. Install CUBRID for PDO driver < 9.1.0, in case CUBRID is not already installed. 
2. Install the `libgcrypt-devel` dependency library, which is required to build PECL packages, because in PHP 5.3.3 installed via YUM this library does not get installed by default.
3. Install CUBRID PDO driver from [PHP PECL Repository](http://pecl.php.net/package/PDO_CUBRID) if the PDO driver is not already installed (*same version as the previously installed CUBRID Database*). If no CUBRID version is specified, defaults to the latest available vesion.
4. Create */etc/php5/conf.d/pdo_cubrid.ini* to tell PHP to load CUBRID PDO driver.

**Note**: this recipe as well as **php_driver** do not restart your Web server automatically because they do not know which Web server you use. So, if necessary, restart your Web server manually.

### CUBRID Perl driver

If you also want to install CUBRID Perl driver, use **perl_driver** recipe. This recipe depends on the **cubrid::default** and **perl::default** recipes.

```
chef.add_recipe "cubrid::perl_driver"
```

This will:

1. Install [DBI](http://dbi.perl.org/) (Database Independent Interface) module which the CUBRID Perl driver is based on.
2. Install CUBRID Perl driver from [CPAN Repository](http://search.cpan.org/~cubrid/) if it is not already installed (*same version as the previously installed CUBRID Database*).

### CUBRID PHP driver

If you also want to install CUBRID PHP driver, use **php_driver** recipe.

#### Dependencies

- [php](https://github.com/opscode-cookbooks/php) cookbook
- if you want to install the PHP driver < v9.1.0, the **cubrid::default** recipe is also required since earlier version require CUBRID to be installed to access the CCI library. Since CUBRID PHP 9.1.0.0003, CCI library is included in PHP driver source code, so doesn't require CUBRID to be installed.

#### Usage

```
chef.add_recipe "cubrid::php_driver"
```

This will:

1. Install CUBRID for PHP driver < 9.1.0, in case CUBRID is not already installed. 
2. Install the `libgcrypt-devel` dependency library, which is required to build PECL packages, because in PHP 5.3.3 installed via YUM this library does not get installed by default.
3. Install CUBRID PHP driver from [PHP PECL Repository](http://pecl.php.net/package/CUBRID) if it is not already installed (*same version as the previously installed CUBRID Database*). If no CUBRID version is specified, defaults to the latest available vesion.
4. Create */etc/php5/conf.d/cubrid.ini* to tell PHP to load CUBRID PHP driver.

**Note**: this recipe as well as **pdo_cubrid** do not restart your Web server automatically because they do not know which Web server you use. So, if necessary, restart your Web server manually.

### CUBRID Python driver

If you also want to install CUBRID Python driver, there are three recipes to choose from:

- **python_driver**: on CentOS 5.x installs the CUBRID Python driver using the *python_driver_source* recipe, otherwise using the *python_driver_pip* recipe.
- **python_driver_pip**: installs pip, virtualenv, and the CUBRID Python driver. pip [requires](http://pypi.python.org/pypi/pip) at least Python 2.5 installed, therefore recommended on CentOS 6+/Ubuntu 10+.
- **python_driver_source**: installs the Python driver from source code. Works on Python 2.4+, therefore recommended on CentOS 5.x.

#### python_driver

If you have no prefereces, use the **python_driver** recipe which will detect the preferred recipe for you to install the Python driver. This recipe depends on the **cubrid::default** recipe.

```
chef.add_recipe "cubrid::python_driver"
```

This will:

1. On CentOS 5.x include the **python_driver_source** recipe, otherwise include the **python_driver_pip** recipe.

#### python_driver_pip

*Recommended on **non**-CentOS 5.x.*

Use the **python_driver_pip** recipe to install the Python driver via pip. This recipe depends on the **cubrid::default** and **python::default** recipes.

```
chef.add_recipe "cubrid::python_driver_pip"
```

This will:

1. Include Python cookbook which installs Python 2.5+, pip, and virtualenv.
2. Install CUBRID Python driver using [pip](http://www.pip-installer.org/en/) from [PYPI](http://pecl.php.net/package/CUBRID) if it is not already installed (*same version as the previously installed CUBRID Database*).

#### python_driver_source

*Recommended on CentOS 5.x.*

Use the **python_driver_source** recipe to install the Python driver from the source code. This recipe depends on the **cubrid::default** and **build-essential::default** recipes.

```
chef.add_recipe "cubrid::python_driver_source"
```

This will:

1. Install the Python Development Package.
2. Download the CUBRID Python driver source archive from [SF.net](https://sourceforge.net/projects/cubrid/files/CUBRID-Drivers/Python_Driver/).
3. Extract it.
4. Build and install the driver library.
5. Remove the extracted directory and the downloaded archive.

**Note:** this **python_driver_source** recipe does not install pip and virtualenv. If necessary, use **python** cookbook to install them.

### CUBRID SHARD

If you want to have your databases sharded by [CUBRID SHARD](http://www.cubrid.org/manual/843/en/CUBRID%20HA) on multi VM environment, use **shard** recipe.

```
chef.json = {
    "cubrid" => {
        "shard_db" => "sharddb",
        "shard_user" => "shard",
        "shard_user_password" => "shard123",
        "shard_hosts" => [
            {"node1" => "10.11.12.13"},
            {"node2" => "10.11.12.14"}
        ],
        "shard_broker_port" => 45011
    }
}

chef.add_recipe "cubrid::shard"
```

This will:

1. Check if `shard_db` and `shard_hosts` attributes are provided by a user. That is, you **must** specify the database name and a list of hosts you want to shard this database among.
If `shard_hosts` is not provided, an error will be raise saying: **Cannot configure CUBRID SHARD without shard_db and shard_hosts. Refer to "shard_db" and "shard_hosts" attributes in /cubrid/attributes/shard.rb for the syntax.**
2. Create and auto start a `shard_db` database, if it is not already created, which will be sharded among `shard_hosts`.
3. Update */etc/hosts* with new **IP - host** values defined in `shard_hosts`, if it is not already updated.
4. Update *conf/shard.conf*.
5. Update *conf/shard_key.txt*.
6. Update *conf/shard_connection.txt*.
7. Start CUBRID SHARD Service on the last of the `shard_hosts`. This means that if you want a specific node to run CUBRID SHARD, list it as the last element of the `shard_hosts` array. You can change the order of hosts anytime after you have started.
8. When installed on CentOS, this **shard** recipe will auto configure the **iptables** firewall if *iptables* is installed. When *iptables* is installed, by default it `REJECT`'s all incoming connections. The **shard** recipe will add an `ACCEPT` rule for CUBRID SHARD port which is **45011** by default.

### MySQL Database Sharding via CUBRID SHARD

CUBRID SHARD allows to configure CUBRID or MySQL as a backend database. If you want to use MySQL as a backend for [CUBRID SHARD](http://www.cubrid.org/manual/843/en/CUBRID%20HA) on multi VM environment, use **shard_mysql** recipe.

This recipe depends on **mysql** and **database** cookbooks.

```
chef.json = {
    "cubrid" => {
        "shard_db" => "sharddb",
        "shard_user" => "shard",
        "shard_user_password" => "shard123",
        "shard_hosts" => [
            {"node1" => "10.11.12.13"},
            {"node2" => "10.11.12.14"}
        ],
        "shard_broker_port" => 45011
    },
    "mysql" => {
        "server_root_password" => "your_root_password",
        "server_repl_password" => "your_root_password",
        "server_debian_password" => "your_root_password"
    }
}

chef.add_recipe "cubrid::shard_mysql"
```

This will:

1. Check if `shard_db` and `shard_hosts` attributes are provided by a user. That is, you **must** specify the database name and a list of hosts you want to shard this database among.
If `shard_hosts` is not provided, an error will be raise saying: **Cannot configure CUBRID SHARD without shard_db and shard_hosts. Refer to "shard_db" and "shard_hosts" attributes in /cubrid/attributes/shard.rb for the syntax.**
2. Update */etc/hosts* with new **IP - host** values defined in `shard_hosts`, if it is not already updated.
3. Install CUBRID and MySQL Servers if they are not installed.
4. Override two MySQL parameters in my.cnf:
	1. `bind_address` to an empty string meaning disable `bind-address`.
	2. `wait_timeout` to [MySQL's default](http://dev.mysql.com/doc/refman/5.1/en/server-system-variables.html#sysvar_wait_timeout) **28800** for CUBRID SHARD to work as expected. See [shard_mysql](https://github.com/kadishmal/cubrid-cookbook/blob/master/recipes/shard_mysql.rb) recipe source for comments.
4. Create a `shard_db` database in MySQL Server, if it is not already created, which will be sharded among `shard_hosts`.
5. Create `shard_user` database user in MySQL and grant all rights to `shard_db` database on `localhost` as well as the remote node where CUBRID SHARD will be started.
5. Update *conf/shard.conf*.
5. Update *conf/shard_key.txt*.
6. Update *conf/shard_connection.txt*.
7. Start CUBRID SHARD Service on the last of the `shard_hosts`. This means that if you want a specific node to run CUBRID SHARD, list it as the last element of the `shard_hosts` array.
8. When installed on CentOS, this **shard_mysql** recipe will auto configure the **iptables** firewall if *iptables* is installed. When *iptables* is installed, by default it `REJECT`'s all incoming connections. The **shard_mysql** recipe will add an `ACCEPT` rule for CUBRID SHARD port which is **45011** by default, and MySQL **3306** port.

### CUBRID Web Manager

If you also want to install CUBRID Web Manager, use **web_manager** recipe. This recipe depends on the **cubrid::default** recipe.

```
chef.add_recipe "cubrid::web_manager"
```

This will:

1. Stop [CUBRID Manager Server](http://www.cubrid.org/manual/90/en/CUBRID%20Manager%20Server) service.
2. Check the version of the installed CUBRID Web Manager.
3. If CWM is not installed or its *patch* version is older than a new available version, download the new package (`tar.gz`) from [CUBRID SF.net repository](http://sourceforge.net/projects/cubrid/files/). CWM version will remain the same as the main CUBRID Database.
4. Extract the downloaded package to */opt/cubrid/*. This will override or add CWM binaries to */bin*, */conf*, and */share* directories.
5. If CUBRID files are not owned by **root**, change ownership to **root**.
6. Remove the downloaded archive and extracted directory.
7. Override the configuration file for CWM, if it is not already overriden.
8. Start CUBRID Manager Server service.
9. When installed on CentOS, this **web_manager** recipe will auto configure the **iptables** firewall if *iptables* is installed. When *iptables* is installed, by default it `REJECT`'s all incoming connections. The **web_manager** recipe will add an `ACCEPT` rule for CUBRID Web Manager port which is **8282** by default.

After CWM is installed, you can access it at [https://your_vm_ip_address:8282](https://your_vm_ip_address:8282). Notice **HTTPS** and **8282** port are used by default. These and other configurations can be adjusted. See [CUBRID Manager HTTPD Variables](http://www.cubrid.org/wiki_tools/entry/cubrid-manager-httpd-variables).

The default username and password to connect to CUBRID Manager Server are **admin/admin**. Once you login for the first time, CWM will prompt you to change the password. Visit [CWM Wiki](http://www.cubrid.org/wiki_tools/entry/cubrid-web-manager) for more information and tutorials.

## TODO

- Test on Fedora.
- Allow users to specify custom port for CUBRID HA.
- Test on a vanilla CentOS.
- Validate the database name.
- Add Chef and Ohai dependency `depends 'chef', '>= 1.1.2'` in metadata.rb.
- In shard_mysql check if Ubuntu version is 10.x.
- Add MySQL 5.5 support which is distributed in Ubuntu 12.04+.
- When setting `max_clients` in cubrid.conf, need to updated the `ulimit` of Linux because by defuault it allows to open 1024 files at a time. Depending on the `max_clients` size, `ulimit` has to be adjusted. See [http://posidev.com/blog/2009/06/04/set-ulimit-parameters-on-ubuntu/](http://posidev.com/blog/2009/06/04/set-ulimit-parameters-on-ubuntu/) for more instructions.
- Add an `init.d` script to start CUBRID service on reboot.
- Add travis testing script.

## License and Authors

Distributed under [MIT License](http://en.wikipedia.org/wiki/MIT_License).

- Esen Sagynov (<kadishmal@gmail.com>)
