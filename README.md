## Description

Provides recipies to install CUBRID Database 9.0 with its demodb database, and CUBRID PDO driver version 9.0. Created to use on Vagrant box.

## Platform

Tested on:

- Ubuntu 10.04 LTS x86/x64 (Vagrant *[lucid32](http://files.vagrantup.com/lucid32.box)*/*[lucid64](http://files.vagrantup.com/lucid64.box)* boxes)
- Ubuntu 12.04 LTS x86/x64 (Vagrant *[precise32](http://files.vagrantup.com/precise32.box)*/*[precise64](http://files.vagrantup.com/precise64.box)* boxes)

##Requirements

This **cubrid** cookbook depends on the following cookbooks:

- *build-essential* and *php* cookbooks for **pdo_cubrid** recipe.

## Recipes

This cookbook provides the following recipes:

- **cubrid**: installs the specified version of CUBRID Database (*default: v9.0*).
- **demodb**: installs CUBRID's [demodb](http://www.cubrid.org/wiki_tutorials/entry/getting-started-with-demodb-cubrid-demo-database) database.
- **php_driver**: installs CUBRID PHP driver (*same version as CUBRID Database*).
- **pdo_cubrid**: installs CUBRID PDO driver (*same version as CUBRID Database, except when CUBRID 8.4.1 is installed in which case PDO driver 8.4.0 is installed as they are compatible*).

## Attributes

See the *attributes/default.rb* for default values.

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

See the *attributes/demodb.rb* for **demodb** specific values.

```
# the default target directory to install CUBRID
default['cubrid']['home']

# the directory where to install the demodb database
set['cubrid']['demodb_dir']
# the full path of a script which install the demodb database
set['cubrid']['demodb_script']
```

See the *attributes/pdo_cubrid.rb* for **pdo_cubrid** specific values.

```
# the default version of CUBRID to install
default['cubrid']['version']

# the version of a CUBRID PDO driver to install from PECL
set['cubrid']['pdo_version']
# the name of a PECL package to install CUBRID PDO driver
node['cubrid']['pdo_package']

# the full path of pdo_cubrid.ini
node['cubrid']['pdo_ext_conf']
# the directives which should be placed in pdo_cubrid.ini files; these are populate to pdo_cubrid.ini.erb template of this cookbook.
node['cubrid']['pdo_directives']
```

See the *attributes/php_driver.rb* for **php_driver** specific values.

```
# the default version of CUBRID to install
default['cubrid']['version']

# the version of a CUBRID PHP driver to install from PECL
set['cubrid']['php_version']
# the name of a PECL package to install CUBRID PHP driver
set['cubrid']['php_package']

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

Alternatively, you can install other versions like 8.4.1 and 8.4.3.

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
5. Start CUBRID Service.

### CUBRID demodb database

If you want to install CUBRID demodb database, use **demodb** recipe. This recipe depends on the **cubrid::default** recipe.

```
chef.add_recipe "cubrid::demodb"
```

This will:

1. Create CUBRID's [demodb](http://www.cubrid.org/wiki_tutorials/entry/getting-started-with-demodb-cubrid-demo-database) database if it's not already created.
6. Auto start **demodb** database.

### CUBRID PHP driver

If you also want to install CUBRID PHP driver, use **php_driver** recipe. This recipe depends on the **cubrid::default** recipe.

```
chef.add_recipe "cubrid::php_driver"
```

This will:

1. Install CUBRID PHP driver from [PHP PECL Repository](http://pecl.php.net/package/CUBRID) if it is not already installed (*same version as the previously installed CUBRID Database*).
2. Create */etc/php5/conf.d/cubrid.ini*.
3. Restart Apache Service.

### CUBRID PDO driver

If you also want to install the PDO driver, use **pdo_cubrid** recipe. This recipe depends on the **cubrid::default** recipe.

```
chef.add_recipe "cubrid::pdo_cubrid"
```

This will:

1. Install CUBRID PDO driver from [PHP PECL Repository](http://pecl.php.net/package/PDO_CUBRID) if the PDO driver is not already installed (*same version as the previously installed CUBRID Database*).
2. Create */etc/php5/conf.d/pdo_cubrid.ini*.
3. Restart Apache Service.

## TODO

1. Test on other **Linux distributions** including Fedora and CentOS.
2. Create recipes for other **CUBRID drivers**: Python, Perl.

## License and Authors

- Esen Sagynov (<kadishmal@gmail.com>)

Distributed under [MIT License](http://en.wikipedia.org/wiki/MIT_License).