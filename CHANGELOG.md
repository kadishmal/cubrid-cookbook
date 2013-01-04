# CHANGELOG for cubrid

This file is used to list changes made in each version of this cubrid cookbook.

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
