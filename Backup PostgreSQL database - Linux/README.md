# README

## Overview

This is a collection of two scripts designed to backup PostgreSQL databases in a Linux server.

When I wrote this script, we had a task to automate backups of these databases and compress them. This script was written to work with CronJob and move the backup to some path pointed by user.

It generates a simple SQL file to be imported into any version of PostgreSQL.

## Backuping with and without compression

There's two files provided: `backup_with_compression.bash` and `backup_without_compression.bash`.

The difference between these two files are only one: the compression. One of them just generates the SQL file (and it's recommended to just run mannualy) and the other compress it with TAR and XZ algorithm with maximum compression.

The XZ with maximum compression consumes time and server resources. So, it's indicated to run it with CronJobs when your server it's on his minimal work hour.

## The configuration

Inside each file there's some variables used to backup, compress and move the files. It generates a simple output based on database name and backup hour.

Both of them shares some variables:

- sHostname :: Hostname where PostgreSQL is installed and listening
- sUsername :: Username allowed to connect into host and access database
- sServicePort :: Port where PostgreSQL is listening
- sDatabase :: Database to connect and backup
- sBackupBasePath :: Absolute path where backup should be generated
- sBackupFinalPath :: Absolute path where backup should be copied (we suggest some network mounted disk)
- sBackupFilename :: Name of generated database

And the file that compress database had one more variable:

- sDateOfMonth :: This variables use the date function from Unix and it's designed, by default, to generate an output with Year, month and day (e.g: 20190101).
