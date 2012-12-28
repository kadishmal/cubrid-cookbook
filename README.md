## Description

Provides recipies to install CUBRID Database 9.0 with its demodb database, and CUBRID PDO driver version 9.0. Created to use on Vagrant box.

## Platform

Tested on:

- Ubuntu 10.04 x86 (Vagrant *lucid32* box)

##Requirements

This **cubrid** cookbook depends on the following cookbooks:

- *build-essential* and *php* cookbooks for **pdo_cubrid** recipe.

## Recipes

This cookbook provides the following recipes:

- **cubrid**: installs CUBRID 9.0 x86.
- **demodb**: installs CUBRID's [demodb](http://www.cubrid.org/wiki_tutorials/entry/getting-started-with-demodb-cubrid-demo-database) database.
- **pdo_cubrid**: installs CUBRID PDO driver 9.0.

## Attributes

See the *attributes/default.rb* for default values.

```
# the version of CUBRID to install
node['cubrid']['version']
# the full version of CUBRID including the build number
node['cubrid']['full_version']

# the file name of the archive to download
node['cubrid']['filename']

# the full URL of the TAR archive to download
node['cubrid']['tar_url']

# the home directory of a Vagrant user
node['cubrid']['user_home_dir']
# the target directory to install CUBRID
node['cubrid']['home']

# the file name of the shell scipt which sets environmental variables for CUBRID
node['cubrid']['env_script_name']
# the full path of the original shell script distributed with CUBRID source
node['cubrid']['env_script_original']
# the target path where the shell script should be placed so that when a user logs in the variables are available.
node['cubrid']['env_script']
```

See the *attributes/demodb.rb* for default values.

```
# the directory where to install the demodb database
node['cubrid']['demodb_dir']
# the full path of a script which install the demodb database
node['cubrid']['demodb_script']
```

See the *attributes/pdo_cubrid.rb* for **pdo_cubrid** specific values.

```
# the name of a PECL package to install CUBRID PDO driver
node['cubrid']['pdo_package']

# the full path of pdo_cubrid.ini
node['cubrid']['pdo_ext_conf']
# the directives which should be placed in pdo_cubrid.ini files; these are populate to pdo_cubrid.ini.erb template of this cookbook.
node['cubrid']['pdo_directives']
```

## Usage

### CUBRID Database

If you want to install only CUBRID 9.0, use **default** recipe.

```
chef.add_recipe "cubrid"
```

This will:

1. Download the latest CUBRID 9.0 (`tar.gz`) from [CUBRID FTP Server](http://ftp.cubrid.org) if CUBRID is not already installed at */opt/cubrid*.
2. Extract it to */opt/cubrid*.
3. Remove the downloaded archive.
4. Set environment variables which are auto loaded when user logs in to the system.
5. Start CUBRID Service.

### CUBRID demodb database

If you want to install CUBRID demodb database, use **demodb** recipe. This recipe depends on the **cubrid::default** recipe.

```
chef.add_recipe "cubrid::demodb"
```

This will:

1. Create CUBRID's [demodb](http://www.cubrid.org/wiki_tutorials/entry/getting-started-with-demodb-cubrid-demo-database) database if it's not already created.
6. Auto start **demodb** database.

### CUBRID PDO driver

If you also want to install the PDO driver, use **pdo_cubrid** recipe. This recipe depends on the **cubrid::default** recipe.

```
chef.add_recipe "cubrid::pdo_cubrid"
```

This will:

1. Download CUBRID PDO driver 9.0 from [PHP PECL Repository](http://pecl.php.net/package/PDO_CUBRID) if the PDO driver is not already installed. It will check the result of `php -i` for the existance of a special CUBRID PDO string.
2. Extract the archive to a user directory.
3. Configure the code with **phpize**.
4. `make install` to */usr/lib/php5/20090626+lfs/pdo_cubrid.so*
5. Create */etc/php5/conf.d/pdo_cubrid.ini*.
6. Remove the downloaded archive as well as the extracted source directory.
7. Restart Apacher Service.

## TODO

1. Test on 64-bit Ubuntu 10.04.
2. Test on other versions of Ubuntu.
3. Test on other **Linux distributions** including Fedora and CentOS.
4. Implement **version support** to allow users to install different versions of CUBRID and the PDO driver.
5. Create recipes for other **CURBID drivers** including PHP, Python, and Perl.

## License and Authors

- Esen Sagynov (<kadishmal@gmail.com>)

Distributed under [MIT License](http://en.wikipedia.org/wiki/MIT_License).