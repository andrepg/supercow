#!/bin/bash

# # # # # #
# #
# # Copyleft (c) Andre Paul Grandsire 2018
# #
# # This script was created to backup and compress big databases.
# # We achieved almost 85% of compression, by costing us a few hours to finish process.
# # At the end, we could archive a 12GB database inside of a 2.5GB XZ tarball file.
# #
# # We currently support any PostgreSQL version that contains pg_dump binaries and
# # generate a SQL file that restore our data in any server. Compatibility first, pal ! \o/
# #
# # There's a few variables to configure, each of them easily named. There's no log for now.
# #
# # # # # #

clear
## Variable declarations, just to make easy to read
sHostname="localhost"
sUsername="BACKUP_JOB"
sServicePort=5432
sDatabase="DATABASE_NAME"
sBackupBasePath=/etc/backup_destiny_path.d
sBackupFinalPath=/media/backup_storage/
sBackupFilename=$sDatabase.sql

if [ -d $dBackupBasePath ]; then
	if [ -d $sBackupFinalPath ]; then 
		## Starting our PostgreSQL dumping process (the backup itself) with verbose mode ( -v )
		## If you don't want verbose mode, just remove the -v parameter. All others are mandatory
		pg_dump -v -h $sHostname -p $sServicePort -U $sUsername $sDatabase > $sBackupFinalPath/$sBackupFilename
	fi
fi