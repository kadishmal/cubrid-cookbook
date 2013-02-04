# CHANGELOG for cubrid

This file is used to list changes made in each version of this cubrid cookbook.

## 1.9.0

- New: Added CentOS 5.6 and 6.0 support.
- Enh: CUBRID Manager Server in 8.4.3 also needs 8003 port open.
- Doc: updated README.

## 1.8.0

- New: added the Perl driver recipe.
- Com: updated the comments.
- Doc: updated README.

## 1.7.0

- New: updated 8.4.3 Python driver from v8.4.3.0001 to v8.4.3.0002.
- New: add "CREATE/ALTER USER" routine to database provider to add a new user when create a new database.
- New: added CUBRID SHARD support. Requires CUBRID 8.4.3+.
- Enh: allow to set a custom SHARD Broker port.
- Enh: automatically open SHARD broker port in iptables on CentOS.
- Enh: check if shard_hosts is defined by a user.
- Doc: fixed the typo.
- Com: updated the comments.

## 1.6.0

- New: added *python_driver* recipe to install CUBRID Python driver.
- Doc: added tutorial links.
- Doc: updated README.

## 1.5.1

- New: auto configure iptables for CentOS support. Tested on CentOS 6.3 x64.
- New: added CentOS support to pdo_cubrid and php_driver recipes. Tested on CentOS 6.3 x64.
- Fix: CWM_EXTRACT_DIR_NAME is already relative to the root. Removed USER_HOME_DIR.
- Fix: remove "sudo" from "ha" recipe as it breaks on CentOS.
- Ref: add a new line to the end of the file.
- Doc: updated README.

## 1.5.0

- New: added CUBRID Web Manager support through **web_manager** recipe.
- Doc: fixed README.
- Doc: updated README.

## 1.4.0

- New: added an "autostart" option to cubrid_database provider.
- New: added CUBRID HA support through "ha" recipe.
- Doc: updated README.
- Com: updated comments.

## 1.3.1

- New: created "cubrid_database" provider to create new databases.
- New: created "new_dbs" recipe which allows to create multiple databases.
- Enh: remove Apache2 dependency from **php_driver** and **pdo_cubrid** recipes.
- Ref: remove unnecessary user definition.
- Com: added comments.
- Doc: updated README.

## 1.3.0

- New: added support for CUBRID 8.4.3 and 8.4.1 as well as corresponding PDO and PHP drivers.
- Enh: improved the check whether or not CUBRID PHP and PDO driver are installed and enabled.
- Doc: updated README.

## 1.2.0

- New: added PHP driver recipe.
- Enh: check if the same version of PDO driver is installed as specified by a user. Used to check only for 9.0.0.
- Doc: updated README.

## 1.1.2

- New: added support for x64 platform.
- Fix: a bug which appeared after last commit.
- Doc: updated README.

## 1.1.1

- Enh: install CUBRID PDO driver from PECL.
- Enh: don't backup downloaded binary archives.
- Enh: add CUBRID global environmental variables.
- Enh: "pdo_cubrid" depends on "build-essential" cookbook in order to "make".
- Enh: consolidated demodb attributes.

## 1.1.0

- New: "demodb" recipe to install CUBRID demodb database.
- Doc: added MIT license file.
- Doc: updated README.

## 1.0.0

- New: initial release of cubrid-chef. Provides recipies to install CUBRID Database 9.0, its demodb database, and PDO_CUBRID 9.0.0.0001.
